import
  uri,
  parseopt,
  httpclient,
  asyncdispatch


const host = "https://stream.neet.space/api"
var client = newAsyncHttpClient()


proc request(query: string, params: seq[(string,string)]) {.async.} =
  let url = parseUri(host) / query ? params
  echo await client.getContent($url)

proc request(query: string) {.async.} =
  let url = parseUri(host) / query
  echo await client.getContent($url)


proc parseArgs() =
  for kind, key, value in getOpt():
    case kind
    of cmdArgument:
      let params = @{ "song": key }
      waitFor request("/submit", params)

    of cmdLongOption, cmdShortOption:
      case key
      of "stat":
        waitFor request("/stat")
      of "queue":
        waitFor request("/queue")
      of "current":
        waitFor request("/current")
      of "skip":
        let params = @{ "username": value }
        waitFor request("/skip", params)
      of "h", "help":
        echo """
        tswf [url] | [OPTIONS]
        --stat          -> length of song queue
        --queue         -> whats in the queue
        --current       -> whats playing now
        --skip=username -> vote to skip as username
        """


    of cmdEnd:
      discard

parseArgs()