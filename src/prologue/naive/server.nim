import httpcore, asyncdispatch
import asynchttpserver except Request
import strutils

import request
import ../nativesettings
import ../context


type
  Server* = AsyncHttpServer

  Prologue* = object
    server*: Server
    settings*: Settings
    router*: Router
    reRouter*: ReRouter
    middlewares*: seq[HandlerAsync]


proc appName*(app: Prologue): string {.inline.} =
  app.settings.appName

proc serve*(app: Prologue, port: Port,
  callback: proc (request: NativeRequest): Future[void] {.closure, gcsafe.},
  address = "") {.async.} =
  await app.server.serve(port, callback, address)

proc close*(app: Prologue) =
  app.server.close()

proc newPrologueServer*(reuseAddr = true, reusePort = false,
                         maxBody = 8388608): Server =
  newAsyncHttpServer(reuseAddr, reusePort, maxBody)