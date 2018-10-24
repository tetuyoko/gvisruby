#!/bin/sh
ruby before_op.rb &&
gviz build graph.ru &&
dot -Tpng ruby.dot -o ruby.png &&
open ruby.png
