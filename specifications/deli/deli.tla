-------------------------------- MODULE Deli --------------------------------
(***************************************************************************)
(* A specification of a simple deli ordering system.                       *)
(***************************************************************************)

CONSTANTS Processes

VARIABLES ticket, worker, customer, state, orderQueue

(***************************************************************************)
(* The current ticket number, worker, customer, state of the deli, and the *)
(* queue of orders.                                                        *)
(***************************************************************************)

TypeOK == 
    /\ ticket \in Nat
    /\ worker \in Processes
    /\ customer \in Processes
    /\ state \in {"Idle", "TakingOrder", "PreparingOrder", "Serving"}
    /\ orderQueue \subseteq Processes

Init ==
    /\ ticket = 0
    /\ worker = Null
    /\ customer = Null
    /\ state = "Idle"
    /\ orderQueue = {}

TakeOrder ==
    \E c \in Processes :
        /\ state = "Idle"
        /\ customer' = c
        /\ worker' = worker
        /\ state' = "TakingOrder"
        /\ ticket' = ticket
        /\ orderQueue' = orderQueue

PrepareOrder ==
    \E w \in Processes :
        /\ state = "TakingOrder"
        /\ worker' = w
        /\ customer' = customer
        /\ state' = "PreparingOrder"
        /\ ticket' = ticket
        /\ orderQueue' = orderQueue

Serve ==
    \E w \in Processes :
        /\ state = "PreparingOrder"
        /\ worker' = w
        /\ customer' = customer
        /\ state' = "Serving"
        /\ ticket' = ticket
        /\ orderQueue' = orderQueue

Next ==
    TakeOrder \/ PrepareOrder \/ Serve

Spec ==
    Init /\ [][Next]_<<ticket, worker, customer, state, orderQueue>>

=============================================================================

