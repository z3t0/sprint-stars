(defpackage :stars
  (:use :common-lisp
	:drakma
	:cl-json)
  (:export :stars))

(in-package :stars)

;; drakma json encoding
(push (cons "application" "json") *text-content-types*)

(defparameter +base_uri+ "https://api.github.com/")

(defmacro build-url (&rest parts)
  `(concatenate 'string ,@parts))

;; Get repos of a user using pagination
(defun get-user-repo-page (user page)
  (decode-json-from-string (http-request (build-url +base_uri+
						    "users/" user "/repos")
					 :parameters `(("per_page" . "100")
						       ("page" . ,page)))))

;; Get all repos of a user
(defun repos (user)
  (let ((pages
	 (ceiling (/ (user-public-repo-count user) 100)))
	(repos))
    (loop for i from 1 to pages
       do (setf repos
		(append (get-user-repo-page user (write-to-string i))
			repos))
       finally (return repos))))

;; get user info
(defun user (user)
  (decode-json-from-string
   (http-request
    (build-url +base_uri+ "users/" user))))

;; number of public repos for the user
(defun user-public-repo-count (user)
  (cdr (assoc :public--repos (user user))))

;; number of stars for the repo
(defun star-for-repo (repo)
  (cdr (assoc :stargazers--count repo)))

;; total stars for user
(defun stars (user)
  (let ((repos (repos user))
	(n 0))
    (loop for repo in repos
       do (setf n (+ n (star-for-repo repo)))
	 finally (return n))))
