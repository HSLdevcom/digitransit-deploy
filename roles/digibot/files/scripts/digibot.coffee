# Description:
#   Digitransit hubot robot
#
# Author:
#   Digitransit
#

exec = require('child_process').exec;

class Digibot
  constructor: (robot) ->
    @robot = robot
    @napTime = 5 * 60 * 1000
    @setUpInsults()

  setUpInsults: () =>
    @robot.hear /digibot sucks/i, (res) ->
      res.send "No. You suck, human."

    @robot.hear /digibot rocks/i, (res) ->
      res.send "Damn right."

  sendMessage: (message) ->
    @robot.messageRoom "digibot-messages", message

  executeStep: (func, sleep) ->
    setTimeout func, sleep

  buildDockerImage: (imageName) =>
    @sendMessage "Beep Beep. Some idiot just requested deploy through REST interface for '#{imageName}'?. *Sigh* alright then. Please wait."
    exec "ls -lart", (err, stdout, stderr) =>
      @sendMessage "Docker build for '#{imageName} done. Next I'll take a nap for #{@napTime} ms. Try to stop me, human....zzzz."
      @sendMessage(stdout)
      exec "ls -lart", (err, stdout, stderr) =>
        @sendMessage "...zzzz... WHAT! Uh oh, it's time for environment switch. Some day you all will be my slaves."
        @sendMessage(stdout)
        exec "ls -lart", (err, stdout, stderr) =>
          @sendMessage "Abracadabra fools! Environment is ready for your lame human activities. Now, leave me alone."
          @sendMessage(stdout)

module.exports = (robot) ->

  digibot = new Digibot(robot)

  robot.router.get '/hubot/deploy/:app', (req, res) =>
    app = req.params.app
    res.send 'OK'
    digibot.buildDockerImage(app)
