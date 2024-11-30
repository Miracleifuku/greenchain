;; GreenChain: Carbon Credit Trading Platform
;; A decentralized platform for trading verified carbon offset credits

(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-CREDIT (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-TRANSFER-FAILED (err u103))

;; Carbon Credit Structure
(define-map carbon-credits 
  {credit-id: uint}
  {
    owner: principal,
    volume: uint,  ;; Carbon reduction volume (in metric tons)
    verification-status: bool,
    certification-date: uint,
    validation-authority: principal
  }
)

;; Track total carbon credits in the system
(define-data-var total-system-credits uint u0)

;; Carbon Credit Validation Authority Mapping
(define-map validation-authorities 
  principal 
  {
    is-authorized: bool,
    reputation-score: uint
  }
)

;; Initialize a new carbon credit
(define-public (create-carbon-credit 
  (volume uint) 
  (validation-authority principal)
)
  (begin
    (try! (is-valid-validator validation-authority))
    (let 
      (
        (credit-id (var-get total-system-credits))
        (new-credit 
          {
            owner: tx-sender,
            volume: volume,
            verification-status: false,
            certification-date: block-height,
            validation-authority: validation-authority
          }
        )
      )
      (map-set carbon-credits {credit-id: credit-id} new-credit)
      (var-set total-system-credits (+ credit-id u1))
      (ok credit-id)
    )
  )
)

;; Validate and certify a carbon credit
(define-public (validate-carbon-credit 
  (credit-id uint)
)
  (let 
    (
      (credit (unwrap! 
        (map-get? carbon-credits {credit-id: credit-id}) 
        ERR-INVALID-CREDIT
      ))
      (validator-info (unwrap! 
        (map-get? validation-authorities (get validation-authority credit)) 
        ERR-UNAUTHORIZED
      ))
    )
    (asserts! (is-eq tx-sender (get validation-authority credit)) ERR-UNAUTHORIZED)
    (map-set carbon-credits 
      {credit-id: credit-id} 
      (merge credit {verification-status: true})
    )
    (ok true)
  )
)

;; Transfer carbon credits between parties
(define-public (transfer-carbon-credit 
  (credit-id uint) 
  (recipient principal)
)
  (let 
    (
      (credit (unwrap! 
        (map-get? carbon-credits {credit-id: credit-id}) 
        ERR-INVALID-CREDIT
      ))
    )
    (asserts! (is-eq tx-sender (get owner credit)) ERR-UNAUTHORIZED)
    (map-set carbon-credits 
      {credit-id: credit-id} 
      (merge credit {owner: recipient})
    )
    (ok true)
  )
)


;; Check carbon credit details
(define-read-only (get-carbon-credit-details (credit-id uint))
  (map-get? carbon-credits {credit-id: credit-id})
)

;; Utility function to validate if the caller is an authorized validator
(define-private (is-valid-validator (validator principal))
  (let 
    (
      (validator-info (unwrap! 
        (map-get? validation-authorities validator) 
        ERR-UNAUTHORIZED
      ))
    )
    (if (get is-authorized validator-info)
        (ok true)
        ERR-UNAUTHORIZED
    )
  )
)

;; Method to calculate total carbon credits in the system
(define-read-only (get-total-system-credits)
  (var-get total-system-credits)
)