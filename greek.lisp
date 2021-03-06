(in-package :stumpwm)

(defvar greek-letters
  '(("alpha - α" "α")
    ("beta - β" "β")
    ("gamma - γ" "γ")
    ("delta - δ" "δ")
    ("epsilon - ε" "ε")
    ("zeta - ζ" "ζ")
    ("eta - η" "η")
    ("theta - θ" "θ")
    ("iota - ι" "ι")
    ("kappa - κ" "κ")
    ("lambda - λ" "λ")
    ("mu - μ" "μ")
    ("nu - ν" "ν")
    ("xi - ξ" "ξ")
    ("omicron - ο" "ο")
    ("pi - π" "π")
    ("rho - ρ" "ρ")
    ("sigma-beginning - σ" "σ")
    ("sigma-end - ς" "ς")
    ("tau - τ" "τ")
    ("upsilon - υ" "υ")
    ("phi - φ" "φ")
    ("chi - χ" "χ" )
    ("omega - ω" "ω")))

(defcommand greek-menu () ()
  (let ((choice (select-from-menu (current-screen)
                                  greek-letters nil 0 nil)))
    (when choice
        (run-shell-command (str:concat "xdotool type \"" (cadr choice) "\"" )))))
