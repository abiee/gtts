Speaker = require 'speaker'
Promise = require 'bluebird'
fs = require 'fs'
cli = require 'cli'
request = require 'request'
lame = require 'lame'

fetchGoogleTTS = (textToSpeech, lang) ->
  idx = 1 # for url generation
  parts = []
  line = []

  # Google do not allow to speech long texts. Cut on pieces smaller than 100
  # chars
  for word in textToSpeech.split ' '
    if line.join(' ').length + word.length < 100
      line.push word
    else
      parts.push line
      line = [word]
  if line.length > 0 then parts.push line

  # Process each part of 100 chars
  Promise.map parts, (line) ->
    text = line.join ' '

    url = "http://translate.google.com/translate_tts?ie=UTF-8&tl=#{lang}&"
    url += "q=#{text}&len=#{text.length}&idx=#{idx++}&total=#{parts.length}"

    new Promise (resolve, reject) ->
      response = request url

      # Put all chunks of data on an array
      chunks = []
      response.on 'data', (data) ->
        chunks.push data

      # Resolve the promise with a buffer which contains all chunks received
      response.on 'end', ->
        resolve Buffer.concat chunks

  .then (buffers) ->
    Buffer.concat buffers

options = cli.parse
  output: ['o', 'Write a mp3 file', 'string']
  notTalk: ['n', 'Not talk']
  lang: ['l', 'Specify your language', 'string', 'es-MX']

cli.withStdinLines (lines, newLine) ->
  cli.spinner 'Sending to google servers...'

  fetchGoogleTTS lines.join(newLine), options.lang
    .then (buffer) ->
      cli.spinner 'Sending to google servers... Done\n', true

      # Convert the buffer in a file
      if options.output
        stream = fs.createWriteStream options.output
        stream.write buffer
        cli.ok "File #{options.output} created!"

      # Send buffer to speakers
      unless options.notTalk
        cli.spinner 'Talking [ctrl+c to exit]...'

        decoder = new lame.Decoder
        speaker = new Speaker

        decoder.pipe speaker
        decoder.write buffer
