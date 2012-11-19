# -*- coding: utf-8 -*-
require 'open-uri'
require 'json'
require 'fileutils'

def getisbn(filename)
  re_str = /^oreilly-(978|979)-([0-9]+)-([0-9]+)-([0-9]+)-([0-9]{1})e.pdf$/ # 正直ISBNのところを(.*)で取得して，ハイフン消したらいいだけ でも正規表現の勉強としてこうしてみた
  if re_str =~ filename
    isbn = $1 + $2 + $3 + $4 + $5
    return isbn
  else
    print(filename + "はフォーマット違うで.\n") # ちゃんとしたメッセージにしよう
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
files.each do |file|
  isbn = getisbn(file)
  if isbn != nil
    json_data = getjson(isbn)
    isbn2title(file, json_data['title'] + ".pdf")
  end
end
