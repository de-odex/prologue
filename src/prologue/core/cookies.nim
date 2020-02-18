import strtabs, parseutils, times, options

from types import SameSite


proc parseCookies*(s: string): StringTableRef =
  result = newStringTable(modeCaseInsensitive)
  var pos = 0
  while true:
    pos += skipWhile(s, {' ', '\t'}, pos)
    var keyStart = pos
    pos += skipUntil(s, {'='}, pos)
    var keyEnd = pos - 1
    if pos >= len(s):
      break
    inc(pos) # skip '='
    var valueStart = pos
    pos += skipUntil(s, {';'}, pos)
    result[s[keyStart .. keyEnd]] = s[valueStart ..< pos]
    if pos >= len(s):
      break
    inc(pos) # skip ';'

proc setCookie*(key, value: string, expires = "", maxAge: Option[int] = none(int), domain = "", path = "",
                 secure = false, httpOnly = false, sameSite = Lax): string {.inline.} =
  result.add key & "=" & value
  if domain != "":
    result.add("; Domain=" & domain)
  if path != "":
    result.add("; Path=" & path)
  if maxAge.isSome:
    result.add("; Max-Age=" & $maxAge)
  if expires != "":
    result.add("; Expires=" & expires)
  if secure:
    result.add("; Secure")
  if httpOnly:
    result.add("; HttpOnly")
  if sameSite != None:
    result.add("; SameSite=" & $sameSite)

proc setCookie*(key, value: string, expires: DateTime|Time, maxAge: Option[
    int] = none(int), domain = "", path = "", secure = false, httpOnly = false,
    sameSite = Lax): string {.inline.} =
  result = setCookie(key, value, format(expires.utc,
      "ddd',' dd MMM yyyy HH:mm:ss 'GMT'"), maxAge, domain, path, secure,
      httpOnly, sameSite)

proc timeForward*(lastingTime: Natural): DateTime =
  getTime().utc + initDuration(seconds = lastingTime)

when isMainModule:
  echo setCookie("useName", "xzsd")
  echo parseCookies("uid=1; kp=2")
