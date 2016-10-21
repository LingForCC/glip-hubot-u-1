# Description:
#   Get a stock price
#
# Commands:
#   stock <ticker> - Get a stock price
#   stock chart <ticker> [1d|5d|2w|1mon|1y] - Get a stock price and chart


module.exports = (robot) ->

  robot.hear /^stock (\S+)$/i, { id: 'stock' }, (msg) ->
    ticker = escape(msg.match[1])
    msg.http('http://finance.google.com/finance/info?client=ig&q=' + ticker)
    .get() (err, res, body) ->
      try
        result = JSON.parse(body.replace(/\/\/ /, ''))
        msg.send ticker.toUpperCase() + ": $"+result[0].l_cur + " (#{result[0].c})" + ' ' + 'http://finance.yahoo.com/q?s=' + ticker
      catch error
        msg.send "Error fetching stock :( " + err

  robot.hear /^stock chart\s?@?([A-Za-z0-9.-_]+)\s?(\d+\w+)?/i, { id: 'stock' }, (msg) ->
    ticker = escape(msg.match[1])
    time = msg.match[2] || '1d'
    msg.http('http://finance.google.com/finance/info?client=ig&q=' + ticker)
      .get() (err, res, body) ->
        try
          result = JSON.parse(body.replace(/\/\/ /, ''))
          msg.send ticker.toUpperCase() + ": $"+result[0].l_cur + " (#{result[0].c})" + ' ' + 'http://finance.yahoo.com/q?s=' + ticker
          msg.send "http://chart.finance.yahoo.com/z?s=#{ticker}&t=#{time}&q=l&l=on&z=l&a=v&p=s&lang=en-US&region=US#.png"
        catch
          msg.send "Error fetching stock :( " + err
