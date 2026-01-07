write:
  export TYPST_ROOT='/Users/csharma/CS/Blog' 
  ./.venv/bin/python ./scripts/writer.py

make:
  ls content/article/* | entr make meta &
  make watch
