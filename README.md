gtts
============
With google text to speech utility you can write text on your terminal and google will read it for you.

How to use it
----------------------
Just clone the repository and hit. Do not forget to install the dependencies with npm.

```sh
$ coffee gtts.coffee
Hola mundo
[ctrl+d]
```

Pretty easy. By default will read the text as es_MX but you can specify your language.

```sh
$ coffee gtts.coffee -l en_US
Hello world
[ctrl+d]
```

If you have a text file and want to listen  instead of read, you can use gtts too.

```sh
$ coffee gtts.coffee -l en_US < my_bored_file.txt
```

Maybe you want to listen after, gtts allows you to create a mp3 file too.

```sh
$ coffee gtts.coffee -l en_US -o ~/my_file.mp3 < my_bored_file.txt
```

And of course, you can only create the mp3 and do not listening the result with -n option.

```sh
$ coffee gtts.coffee -l en_US -n -o ~/my_file.mp3 < my_bored_file.txt
```

Know issues
----------------------
Exit when finish instead ctrl+c.
