(define-map leaderboard ((id int)) ((name (string-ascii 20)) (score int)))

(define-public (add-player (id int) (name (string-ascii 20)))
  (insert-entry! leaderboard { id: id } { name: name, score: 0 }))

(define-public (update-score (id int) (new-score int))
  (let ((entry (unwrap-panic (map-get? leaderboard { id: id }))))
    (if (is-eq new-score (get score entry))
        (ok true)
        (begin
          (update-entry! leaderboard { id: id } { name: (get name entry), score: new-score })
          (ok true)))))

(define-read-only (get-leaderboard)
  (map 
    (lambda (id entry) 
      { name: (get name entry), score: (get score entry) }) 
    (fold 
      (lambda (id acc) 
        (unwrap-panic (map-insert acc id (unwrap-panic (map-get? leaderboard id))))) 
      (list) 
      (map-keys leaderboard))))