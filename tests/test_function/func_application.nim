import ../../src/prologue

import unittest


proc hello*(ctx: Context) {.async.} =
  resp "<h1>Hello, Prologue!</h1>"

proc helloName*(ctx: Context) {.async.} =
  resp "<h1>Hello, " & ctx.getPathParams("name", "Prologue") & "</h1>"

proc articles*(ctx: Context) {.async.} =
  resp $ctx.getPathParams("num", 1)

proc go404*(ctx: Context) {.async.} = 
  resp "Something wrong!"

proc go20x*(ctx: Context) {.async.} = 
  resp "Ok!"

proc go30x*(ctx: Context) {.async.} = 
  resp "EveryThing else?"


suite "Func Test":
  test "serveStaticFile can work":
    let settings = newSettings()
    var app = newApp(settings)
    app.serveStaticFile("templates")
    check app.settings.staticDirs.len == 2
    check app.settings.staticDirs[0] == "static"
    check app.settings.staticDirs[1] == "templates"

  test "serveStaticFiles can work":
    let settings = newSettings()
    var app = newApp(settings)
    app.serveStaticFile(@["templates", "css"])
    check app.settings.staticDirs.len == 3
    check app.settings.staticDirs[0] == "static"
    check app.settings.staticDirs[1] == "templates"
    check app.settings.staticDirs[2] == "css"

  test "registErrorHandler can work":
    let settings = newSettings()
    var app = newApp(settings)
    app.registerErrorHandler(Http404, go404)
    app.registerErrorHandler({Http200 .. Http204}, go20x)
    app.registerErrorHandler(@[Http301, Http304, Http307], go30x)
    check app.errorHandlerTable[Http404] == go404
    check app.errorHandlerTable[Http202] == go20x
    check app.errorHandlerTable[Http304] == go30x

    


  test "addRoute can work":
    let settings = newSettings()
    var app = newApp(settings)
    app.addRoute("/", hello)
    app.addRoute("/hello/{name}", helloName, @[HttpGet, HttpPost])
    app.addRoute(re"/post(?P<num>[\d]+)", articles, HttpGet)
    check app.router.callable[initPath("/", HttpGet)].handler == hello
    check app.router.callable[initPath("/", HttpHead)].handler == hello
    check app.router.callable[initPath("/hello/{name}", HttpPost)].handler == helloName
    check app.reRouter.callable[0][1].handler == articles
