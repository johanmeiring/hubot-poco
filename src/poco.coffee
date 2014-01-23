# Description:
#   South African Postal Code lookup
#
# Dependencies:
#   "hubot-podbaydoors": "1.0.x"
#   "hubot-poco": "1.0.x"
#
#
# Configuration:
#   None
#
# Commands:
#   hubot poco <suburb|postal code> - Displays a formatted response from poco.co.za. Limited to 5 results.
#
# Author:
#   johanmeiring

module.exports = (robot) ->
  regex = /poco (.*)/i
  robot.respond regex, (msg) ->
    location = msg.match[1]

    performSearch msg, location, (results) ->
      msg.send results

performSearch = (msg, location, callback) ->
  processResult = (err, res, body) ->
    return msg.send err if err
    if res.statusCode == 301
      msg.http(res.headers.location).get() processResult
      return
    if res.statusCode > 300
      msg.reply "Sorry, I couldn't search for that location. Unexpected status from poco.co.za: #{res.statusCode}"
      return
    try
      result_array = JSON.parse(body)
    catch error
      msg.reply "Sorry, I couldn't search for that location. Unexpected response from poco.co.za: #{body}"
    if result_array?
      if result_array.length > 0
        results = ''
        for i in [0..Math.min(result_array.length-1, 4)] by 1
          unless result_array[i].suburb == ''
            results = "#{results}Suburb: #{result_array[i].suburb}; "
          unless result_array[i].area == ''
            results = "#{results}Area: #{result_array[i].area}; "
          unless result_array[i].postal == ''
            results = "#{results}Postal Code: #{result_array[i].postal}; "
          unless result_array[i].street == ''
            results = "#{results}Street Code: #{result_array[i].street}; "
          results = "#{results}\n"
        callback results
      else
        callback "No results were found for #{location} :("
    else
      msg.reply 'Sorry, I couldn\'t search for that location.'

  msg.http('http://poco.co.za/api/locations/')
  .query(
    search: location
  ).get() processResult
