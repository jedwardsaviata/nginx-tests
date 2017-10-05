childProcess = require 'child_process'

exec = (command, options) ->
  new Promise (resolve, reject) ->
    childProcess.exec command, options, (error, stdout, stderr) ->
      if error?
        error.stdout = stdout if stdout?
        error.stderr = stderr if stderr?
        reject error
      else
        resolve
          stdout: stdout
          stderr: stderr

module.exports = exec

