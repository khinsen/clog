(in-package :clog-tools)

(defun on-show-control-events-win (obj)
  "Show control events window"
  (let ((app (connection-data-item obj "builder-app-data")))
    (if (control-events-win app)
        (window-focus (control-events-win app))
        (let* ((*default-title-class*      *builder-title-class*)
               (*default-border-class*     *builder-border-class*)
               (win     (create-gui-window obj :title "Control CLOG Events"
                                               :has-pinner t :client-movement *client-side-movement*))
               (content (window-content win))
               save delete
               status)
          (set-geometry win
                        :top "" :bottom 5
                        :right 405 :left (+ *builder-left-panel-size* 5)
                        :width "" :height 300)
          (set-geometry win :width (width win) :right "")
          (set-on-window-focus win
                               (lambda (obj)
                                 (declare (ignore obj))
                                 (setf (current-editor-is-lisp app) t))) ; when t looks up panels package
          (setf (control-events-win app) win)
          (setf (events-list app) (create-select content :name "clog-events" :class *builder-event-list-class*))
          (setf (size (events-list app)) 5)
          (setf (positioning (events-list app)) :absolute)
          (set-geometry (events-list app) :top 5 :left 5 :bottom 5 :width 250)
          (setf (event-editor app) (clog-ace:create-clog-ace-element content))
          (setf (clog-ace:read-only-p (event-editor app)) t)
          (setf save (create-button content :content "save" :style "position:absolute;" :class "w3-tiny"))
          (set-geometry save :top 5 :left 260 :width 60 :height 25)
          (setf delete (create-button content :content "delete" :style "position:absolute;" :class "w3-tiny"))
          (set-geometry delete :top 5 :left 325 :width 60 :height 25)
          (setf (event-info app) (create-form-element content :text
                                                      :value "event info"
                                                      :style "position:absolute;"
                                                      :class "w3-tiny w3-border"))
          (setf (read-only-p (event-info app)) t)
          (set-geometry (event-info app) :top 5 :left 390 :right 5 :width "" :height 25)
          (labels ((save-event (obj)
                     (declare (ignore obj))
                     (focus (events-list app))
                     (focus (event-editor app)))
                   (delete-event (obj)
                     (declare (ignore obj))
                     (focus (event-editor app))
                     (setf (text-value (event-editor app)) "")
                     (focus (events-list app))
                     (focus (event-editor app))))
            (set-on-event (event-editor app) "clog-save-ace" #'save-event)
            (set-on-click save #'save-event)
            (set-on-click delete #'delete-event))
          (setf (positioning (event-editor app)) :absolute)
          (setf (width (event-editor app)) "")
          (setf (height (event-editor app)) "")
          (set-geometry (event-editor app) :top 35 :left 260 :right 5 :bottom 30)
          (clog-ace:resize (event-editor app))
          (setf status (create-form-element content :text :class "w3-tiny w3-border"))
          (setf (positioning status) :absolute)
          (setf (width status) "")
          (set-geometry status :height 20 :left 260 :right 5 :bottom 5)
          (setf (clog-ace:mode (event-editor app)) "ace/mode/lisp")
          (setf (current-editor-is-lisp app) "CLOG-USER")
          (setup-lisp-ace (event-editor app) status :package "CLOG-USER")
          (set-on-window-size-done win (lambda (obj)
                                         (declare (ignore obj))
                                         (clog-ace:resize (event-editor app))))
          (set-on-window-close win (lambda (obj)
                                     (declare (ignore obj))
                                     (setf (event-editor app) nil)
                                     (setf (event-info app) nil)
                                     (setf (events-list app) nil)
                                     (setf (control-events-win app) nil))))))
  (on-populate-control-events-win obj))

(defun on-show-control-js-events-win (obj)
  "Show control events window"
  (let ((app (connection-data-item obj "builder-app-data")))
    (if (control-js-events-win app)
        (window-focus (control-js-events-win app))
        (let* ((*default-title-class*      *builder-title-class*)
               (*default-border-class*     *builder-border-class*)
               (win     (create-gui-window obj :title "Control Client JavaScript Events"
                                               :left (+ *builder-left-panel-size* 5)
                                               :height 200 :width 645
                                               :has-pinner t :client-movement *client-side-movement*))
               (content (window-content win))
               status)
          (set-geometry win :top "" :bottom 0)
          (setf (current-editor-is-lisp app) nil)
          (set-on-window-focus win
                               (lambda (obj)
                                 (declare (ignore obj))
                                 (setf (current-editor-is-lisp app) nil)))
          (setf (control-js-events-win app) win)
          (setf (events-js-list app) (create-select content :name "clog-js-events" :class *builder-event-list-class*))
          (setf (positioning (events-js-list app)) :absolute)
          (set-geometry (events-js-list app) :top 5 :left 5 :right 5)
          (setf (event-js-editor app) (clog-ace:create-clog-ace-element content))
          (setf (clog-ace:read-only-p (event-js-editor app)) t)
          (set-on-event (event-js-editor app) "clog-save-ace"
                        (lambda (obj)
                          (declare (ignore obj))
                          ;; toggle focus to force a save of event
                          (focus (events-js-list app))
                          (focus (event-js-editor app))))
          (setf (positioning (event-js-editor app)) :absolute)
          (setf (width (event-js-editor app)) "")
          (setf (height (event-js-editor app)) "")
          (set-geometry (event-js-editor app) :top 35 :left 5 :right 5 :bottom 30)
          (clog-ace:resize (event-js-editor app))
          (setf status (create-div content :class "w3-tiny w3-border"
                                           :content "Use $(\"data-clog-name='control-name']\") to access controls."))
          (setf (positioning status) :absolute)
          (setf (width status) "")
          (set-geometry status :height 20 :left 5 :right 5 :bottom 5)
          (setup-lisp-ace (event-js-editor app) nil :package "clog-user")
          (setf (clog-ace:mode (event-js-editor app)) "ace/mode/javascript")
          (set-on-window-size-done win (lambda (obj)
                                         (declare (ignore obj))
                                         (clog-ace:resize (event-js-editor app))))
          (set-on-window-close win (lambda (obj)
                                     (declare (ignore obj))
                                     (setf (event-js-editor app) nil)
                                     (setf (events-js-list app) nil)
                                     (setf (control-js-events-win app) nil))))))
  (on-populate-control-js-events-win obj))

(defun on-show-control-ps-events-win (obj)
  "Show control events window"
  (let ((app (connection-data-item obj "builder-app-data")))
    (if (control-ps-events-win app)
        (window-focus (control-ps-events-win app))
        (let* ((*default-title-class*      *builder-title-class*)
               (*default-border-class*     *builder-border-class*)
               (win     (create-gui-window obj :title "Control Client ParenScript Events"
                                               :left (+ *builder-left-panel-size* 5)
                                               :height 200 :width 645
                                               :has-pinner t :client-movement *client-side-movement*))
               (content (window-content win))
               status)
          (set-geometry win :top "" :bottom 0)
          (setf (current-editor-is-lisp app) nil)
          (set-on-window-focus win
                               (lambda (obj)
                                 (declare (ignore obj))
                                 (setf (current-editor-is-lisp app) nil)))
          (setf (control-ps-events-win app) win)
          (setf (events-ps-list app) (create-select content :name "clog-ps-events" :class *builder-event-list-class*))
          (setf (positioning (events-ps-list app)) :absolute)
          (set-geometry (events-ps-list app) :top 5 :left 5 :right 5)
          (setf (event-ps-editor app) (clog-ace:create-clog-ace-element content))
          (setf (clog-ace:read-only-p (event-ps-editor app)) t)
          (set-on-event (event-ps-editor app) "clog-save-ace"
                        (lambda (obj)
                          (declare (ignore obj))
                          ;; toggle focus to force a save of event
                          (focus (events-ps-list app))
                          (focus (event-ps-editor app))))
          (setf (positioning (event-ps-editor app)) :absolute)
          (setf (width (event-ps-editor app)) "")
          (setf (height (event-ps-editor app)) "")
          (set-geometry (event-ps-editor app) :top 35 :left 5 :right 5 :bottom 30)
          (clog-ace:resize (event-ps-editor app))
          (setf status (create-div content :class "w3-tiny w3-border"
                                           :content "Use (ps:chain ($ \"[data-clog-name=\\\"control-name\\\"]\")) to access controls."))
          (setf (positioning status) :absolute)
          (setf (width status) "")
          (set-geometry status :height 20 :left 5 :right 5 :bottom 5)
          (setup-lisp-ace (event-ps-editor app) nil :package "parenscript")
          (set-on-window-size-done win (lambda (obj)
                                         (declare (ignore obj))
                                         (clog-ace:resize (event-ps-editor app))))
          (set-on-window-close win (lambda (obj)
                                     (declare (ignore obj))
                                     (setf (event-ps-editor app) nil)
                                     (setf (events-ps-list app) nil)
                                     (setf (control-ps-events-win app) nil))))))
  (on-populate-control-ps-events-win obj))

(defun on-populate-control-events-win (obj)
  "Populate the control events for the current control"
  (when obj
    (let* ((app       (connection-data-item obj "builder-app-data"))
           (event-win (control-events-win app))
           (elist     (events-list app))
           (control   (current-control app)))
      (when event-win
        (set-on-blur (event-editor app) nil)
        (set-on-change elist nil)
        (setf (inner-html elist) "")
        (remove-attribute elist "data-current-event")
        (setf (text-value (event-editor app)) "")
        (setf (text-value (event-info app)) "")
        (browser-gc obj)
        (setf (clog-ace:read-only-p (event-editor app)) t)
        (when control
          (let ((info (control-info (attribute control "data-clog-type"))))
            (labels ((populate-options (&key (current ""))
                       (set-on-change elist nil)
                       (setf (inner-html elist) "")
                       (add-select-option elist "" "Select Event")
                       (dolist (event (getf info :events))
                         (let* ((attr (format nil "data-~A" (getf event :name)))
                                (opt  (add-select-option elist
                                                         (getf event :name)
                                                         (format nil "~A ~A"
                                                                 (if (has-attribute control attr)
                                                                     "&#9632; "
                                                                     "&#9633; ")
                                                                 (getf event :name))
                                                         :selected (equal attr current))))
                           (set-on-click opt (lambda (obj)
                                               (declare (ignore obj))
                                               (setf (text-value (event-editor app)) "")
                                               (setf (text-value (event-info app))
                                                     (format nil "~A (panel ~A)"
                                                             (getf event :name)
                                                             (getf event :parameters)))))))
                       (set-on-change elist #'on-change))
                     (on-blur (obj)
                       (declare (ignore obj))
                       (set-on-blur (event-editor app) nil)
                       (let ((attr (attribute elist "data-current-event")))
                         (unless (equalp attr "undefined")
                           (let ((opt (select-text elist))
                                 (txt (text-value (event-editor app))))
                             (when (equalP (format nil "data-~A" (text-value elist)) attr)
                               (setf (char opt 0) #\space)
                               (setf opt (string-left-trim "#\space" opt))
                               (cond ((or (equal txt "")
                                          (equalp txt "undefined"))
                                       (setf (select-text elist) (format nil "~A ~A" (code-char 9633) opt))
                                       (remove-attribute control attr))
                                     (t
                                       (setf (select-text elist) (format nil "~A ~A" (code-char 9632) opt))
                                       (setf (attribute control attr) txt)))))
                           (jquery-execute (get-placer control) "trigger('clog-builder-snap-shot')")))
                       (set-on-blur (event-editor app) #'on-blur))
                     (on-change (obj)
                       (declare (ignore obj))
                       (set-on-blur (event-editor app) nil)
                       (let ((event (text-value elist)))
                         (cond ((equal event "")
                                (set-on-blur (event-editor app) nil)
                                (remove-attribute elist "data-current-event")
                                (setf (text-value (event-editor app)) "")
                                (setf (text-value (event-info app)) "")
                                (setf (clog-ace:read-only-p (event-editor app)) t))
                               (t
                                (setf (clog-ace:read-only-p (event-editor app)) nil)
                                (let* ((attr (format nil "data-~A" event))
                                       (txt  (attribute control attr)))
                                  (setf (text-value (event-editor app))
                                        (if (equalp txt "undefined")
                                            ""
                                            txt))
                                  (setf (attribute elist "data-current-event") attr)
                                  (set-on-blur (event-editor app) #'on-blur)))))))
              (populate-options))))))
    (on-populate-control-ps-events-win obj)
    (on-populate-control-js-events-win obj)))

(defun on-populate-control-js-events-win (obj)
  "Populate the control js events for the current control"
  (let* ((app       (connection-data-item obj "builder-app-data"))
         (event-win (control-js-events-win app))
         (elist     (events-js-list app))
         (control   (current-control app)))
    (when event-win
      (set-on-blur (event-js-editor app) nil)
      (set-on-change elist nil)
      (setf (inner-html elist) "")
      (remove-attribute elist "data-current-js-event")
      (setf (text-value (event-js-editor app)) "")
      (browser-gc obj)
      (setf (clog-ace:read-only-p (event-js-editor app)) t)
      (when control
        (let ((info (control-info (attribute control "data-clog-type"))))
          (labels ((populate-options (&key (current ""))
                     (set-on-change elist nil)
                     (setf (inner-html elist) "")
                     (add-select-option elist "" "Select JS Event")
                     (dolist (event (getf info :events))
                       (when (getf event :js-event)
                         (let ((attr (format nil "~A" (getf event :js-event))))
                           (add-select-option elist
                                              (getf event :js-event)
                                              (format nil "~A ~A"
                                                      (if (has-attribute control attr)
                                                          "&#9632; "
                                                          "&#9633; ")
                                                      (getf event :js-event))
                                              :selected (equal attr current)))))
                     (set-on-change elist #'on-change))
                   (on-blur (obj)
                     (declare (ignore obj))
                     (set-on-blur (event-js-editor app) nil)
                     (let ((attr (attribute elist "data-current-js-event")))
                       (unless (equalp attr "undefined")
                         (let ((opt (select-text elist))
                               (txt (text-value (event-js-editor app))))
                           (setf (char opt 0) #\space)
                           (setf opt (string-left-trim "#\space" opt))
                           (cond ((or (equal txt "")
                                      (equalp txt "undefined"))
                                  (setf (select-text elist) (format nil "~A ~A" (code-char 9633) opt))
                                  (remove-attribute control attr))
                                 (t
                                  (setf (select-text elist) (format nil "~A ~A" (code-char 9632) opt))
                                  (setf (attribute control attr) txt))))
                         (jquery-execute (get-placer control) "trigger('clog-builder-snap-shot')")))
                     (set-on-blur (event-js-editor app) #'on-blur))
                   (on-change (obj)
                     (declare (ignore obj))
                     (set-on-blur (event-js-editor app) nil)
                     (let ((event (select-value elist "clog-js-events")))
                       (cond ((equal event "")
                              (set-on-blur (event-js-editor app) nil)
                              (remove-attribute elist "data-current-js-event")
                              (setf (text-value (event-js-editor app)) "")
                              (setf (clog-ace:read-only-p (event-js-editor app)) t))
                             (t
                              (setf (clog-ace:read-only-p (event-js-editor app)) nil)
                              (let* ((attr (format nil "~A" event))
                                     (txt  (attribute control attr)))
                                (setf (text-value (event-js-editor app))
                                      (if (equalp txt "undefined")
                                          ""
                                          txt))
                                (setf (attribute elist "data-current-js-event") attr)
                                (set-on-blur (event-js-editor app) #'on-blur)))))))
            (populate-options)))))))

(defun on-populate-control-ps-events-win (obj)
  "Populate the control ps events for the current control"
  (let* ((app       (connection-data-item obj "builder-app-data"))
         (event-win (control-ps-events-win app))
         (elist     (events-ps-list app))
         (control   (current-control app)))
    (when event-win
      (set-on-blur (event-ps-editor app) nil)
      (set-on-change elist nil)
      (setf (inner-html elist) "")
      (remove-attribute elist "data-current-ps-event")
      (setf (text-value (event-ps-editor app)) "")
      (browser-gc obj)
      (setf (clog-ace:read-only-p (event-ps-editor app)) t)
      (when control
        (let ((info (control-info (attribute control "data-clog-type"))))
          (labels ((populate-options (&key (current ""))
                     (set-on-change elist nil)
                     (setf (inner-html elist) "")
                     (add-select-option elist "" "Select JS Event for ParenScript")
                     (dolist (event (getf info :events))
                       (when (getf event :js-event)
                         (let ((attr (format nil "~A" (getf event :js-event))))
                           (add-select-option elist
                                              (getf event :js-event)
                                              (format nil "~A ~A"
                                                      (if (has-attribute control attr)
                                                          "&#9632; "
                                                          "&#9633; ")
                                                      (getf event :js-event))
                                              :selected (equal attr current)))))
                     (set-on-change elist #'on-change))
                   (on-blur (obj)
                     (declare (ignore obj))
                     (set-on-blur (event-ps-editor app) nil)
                     (let* ((attr    (attribute elist "data-current-ps-event"))
                            (ps-attr (format nil "data-ps-~A" attr)))
                       (unless (equalp attr "undefined")
                         (let ((opt (select-text elist))
                               (txt (text-value (event-ps-editor app))))
                           (setf (char opt 0) #\space)
                           (setf opt (string-left-trim "#\space" opt))
                           (cond ((or (equal txt "")
                                      (equalp txt "undefined"))
                                  (setf (select-text elist) (format nil "~A ~A" (code-char 9633) opt))
                                  (remove-attribute control ps-attr)
                                  (remove-attribute control attr))
                                 (t
                                  (setf (select-text elist) (format nil "~A ~A" (code-char 9632) opt))
                                  (setf (attribute control ps-attr) txt)
                                  (let ((ss (make-string-input-stream txt)))
                                    (setf (attribute control attr) (ps:ps-compile-stream ss)))))
                         (jquery-execute (get-placer control) "trigger('clog-builder-snap-shot')"))))
                     (set-on-blur (event-ps-editor app) #'on-blur))
                   (on-change (obj)
                     (declare (ignore obj))
                     (set-on-blur (event-ps-editor app) nil)
                     (let ((event (select-value elist "clog-ps-events")))
                       (cond ((equal event "")
                              (set-on-blur (event-ps-editor app) nil)
                              (remove-attribute elist "data-current-ps-event")
                              (setf (text-value (event-ps-editor app)) "")
                              (setf (clog-ace:read-only-p (event-ps-editor app)) t))
                             (t
                              (setf (clog-ace:read-only-p (event-ps-editor app)) nil)
                              (let* ((attr    (format nil "~A" event))
                                     (ps-attr (format nil "data-ps-~A" attr))
                                     (txt     (attribute control ps-attr)))
                                (setf (text-value (event-ps-editor app))
                                      (if (equalp txt "undefined")
                                          ""
                                          txt))
                                (setf (attribute elist "data-current-ps-event") attr)
                                (set-on-blur (event-ps-editor app) #'on-blur)))))))
            (populate-options)))))))
