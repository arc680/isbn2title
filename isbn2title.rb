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
  json_data = ""
  open(uri) do |f|
    json_data = JSON.load(f)
  end
  return json_data
end

def isbn2title(filename, new_filename, extname)
  FileUtils.cp(filename, "./renamed/" + new_filename + extname)
  print(filename + " -> " + new_filename + extname + "\n")
end


if File.exists?("./renamed") == false
  Dir.mkdir("./renamed")
end

files = Dir.glob(["*.pdf", "*.epub"])
files.each do |file|
  extname = File.extname(file)
  isbn = getisbn(file)
  if isbn != nil
    json_data = getjson(isbn)
    isbn2title(file, json_data['title'], extname) # epubにも対応できるようにしよう
  end
end
