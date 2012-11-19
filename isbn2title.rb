# -*- coding: utf-8 -*-
require 'open-uri'
require 'json'
require 'fileutils'

def getisbn(filename)
  re_str = /^oreilly-(978|979)-([0-9]+)-([0-9]+)-([0-9]+)-([0-9]{1})e.pdf$/ # 正直ISBNのところを(.*)で取得して，ハイフン消したらいいだけ でも正規表現の勉強としてこうしてみた
  if re_str =~ filename
    isbn = $1 + $2 + $3 + $4 + $5
    if isbn.length == 13
      return isbn
    else
      print("13桁ちゃうで\n")
    end
  else
    print("フォーマット違うで.\n")
  end
end

def getjson(isbn)
  uri = "http://www.oreilly.co.jp/books/" + isbn + "/biblio.json"
  json = ""
  open(uri) do |f|
    json += f.read
  end
  return JSON.parse(json)
end

def isbn2title(filename, new_filename)
  FileUtils.cp(filename, "./renamed/" + new_filename)
  print(filename + " -> " + new_filename + "\n")
end


if File.exists?("./renamed") == false
  Dir.mkdir("./renamed")
end

files = Dir.glob("*.pdf")
isbn = getisbn(files[0])
if isbn != nil
  json_data = getjson(isbn)
  isbn2title(ARGV[0], json_data['title'] + ".pdf")
end
