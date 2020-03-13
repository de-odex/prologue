import os, osproc, strformat

import unittest


suite "Test Examples":
  let
    helloWorldDir = "./examples/helloworld"
    todoListDir = "./examples/todoList"
    blogDir = "./examples/blog"
    app = "app.nim"
  echo getCurrentDir()
  test "helloworld can compile":
    let (o, errC) = execCmdEx(fmt"nim c --hints:off {helloWorldDir / app}")
    echo o
    check errC == 0

  test "todolist can compile":
    let (_, errC) = execCmdEx(fmt"nim c --hints:off {todoListDir / app}")
    check errC == 0

  test "blog can compile":
    let (_, errC) = execCmdEx(fmt"nim c --hints:off {blogDir / app}")
    check errC == 0
