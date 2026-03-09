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

