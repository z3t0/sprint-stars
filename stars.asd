(defsystem "stars"
  :depends-on ("drakma" "cl-json" "xmls")
  :components ((:file "stars"))
  :license "GPL-v3.0"
  :author "Rafi Khan"
  :description "Uses GitHub's HTTP API to return the total number of stars for a user")
