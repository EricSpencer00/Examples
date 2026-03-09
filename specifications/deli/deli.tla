-------------------------------- MODULE deli --------------------------------
(***************************************************************************)
(* A specification of a simple deli ordering system with a ticket queue.   *)
(* Customers arrive, get assigned to a worker, their order is prepared,    *)
(* and then served. The system cycles through Idle → TakingOrder →         *)
(* PreparingOrder → Serving → ReturnToIdle to serve the next customer.     *)
(***************************************************************************)

EXTENDS Naturals, Sequences

CONSTANTS Processes, Null, MaxArrivals

VARIABLES ticket, worker, customer, state, orderQueue, arrivals

(***************************************************************************)
(* State variables:                                                        *)
(*  - ticket: increasing counter issued to arriving customers              *)
(*  - worker: the current worker serving an order, or Null if idle         *)
(*  - customer: the current customer being served, or Null if idle         *)
(*  - state: the system's current phase:                                   *)
(*          (Idle | TakingOrder | PreparingOrder | Serving)                *)
(*  - orderQueue: sequence of customers waiting to be served               *)
(***************************************************************************)

TypeOK == 
    /\ ticket \in Nat
    /\ worker \in Processes \cup {Null}
    /\ customer \in Processes \cup {Null}
    /\ state \in {"Idle", "TakingOrder", "PreparingOrder", "Serving"}
    /\ orderQueue \in Seq(Processes)
    /\ arrivals \in Nat

Init ==
    /\ ticket = 0
    /\ worker = Null
    /\ customer = Null
    /\ state = "Idle"
    /\ orderQueue = <<>>
    /\ arrivals = 0

(* Customer arrives, gets a ticket number, and joins the queue *)
TakeOrder ==
    /\ state = "Idle"
    /\ arrivals < MaxArrivals
    /\ \E c \in Processes :
        /\ ticket' = ticket + 1
        /\ arrivals' = arrivals + 1
        /\ orderQueue' = Append(orderQueue, c)
        /\ state' = "TakingOrder"
        /\ UNCHANGED <<worker, customer>>

(* The next customer from the queue is called and a worker is assigned *)
PrepareOrder ==
    /\ state = "TakingOrder"
    /\ Len(orderQueue) > 0
    /\ LET c == Head(orderQueue) IN
        /\ \E w \in Processes :
            /\ customer' = c
            /\ worker' = w
            /\ orderQueue' = Tail(orderQueue)
            /\ state' = "PreparingOrder"
        /\ UNCHANGED <<ticket, arrivals>>

(* The assigned worker serves the current customer *)
Serve ==
    /\ state = "PreparingOrder"
    /\ state' = "Serving"
    /\ UNCHANGED <<ticket, worker, customer, orderQueue, arrivals>>

(* Customer is served, worker and customer reset, ready for the next order *)
ReturnToIdle ==
    /\ state = "Serving"
    /\ state' = "Idle"
    /\ worker' = Null
    /\ customer' = Null
    /\ UNCHANGED <<ticket, orderQueue, arrivals>>

Next ==
    TakeOrder \/ PrepareOrder \/ Serve \/ ReturnToIdle

(* Safety: System stays in one of the allowed states *)
ValidStates ==
    state \in {"Idle", "TakingOrder", "PreparingOrder", "Serving"}

(* Safety: At most one customer is being served at any given time *)
MutualExclusion ==
    (state = "Idle") => (customer = Null /\ worker = Null)

Spec ==
    Init /\ [][Next]_<<ticket, worker, customer, state, orderQueue, arrivals>>

(* Theorems *)
THEOREM Spec => []TypeOK
THEOREM Spec => []ValidStates  
THEOREM Spec => []MutualExclusion

=============================================================================

