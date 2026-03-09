-------------------------------- MODULE deli --------------------------------
(***************************************************************************)
(* A specification of a deli ordering system with concurrent workers.      *)
(* Customers arrive (Arrive) and join a queue. Idle workers asynchronously *)
(* pick up waiting customers (AssignOrder), then complete their order      *)
(* (CompleteOrder) and return to Idle. Multiple workers process orders     *)
(* in parallel, and customers can arrive unboundedly.                      *)
(***************************************************************************)

EXTENDS Naturals, Sequences

CONSTANTS Workers, Customers, Null

VARIABLES orderQueue,          \* Seq(Customers) — grows at any time
          workerState,         \* [Workers -> {"Idle","Preparing"}]
          workerCustomer       \* [Workers -> Customers ∪ {Null}]

(***************************************************************************)
(* State variables:                                                        *)
(*  - orderQueue: sequence of customers waiting to be served               *)
(*  - workerState: mapping from workers to their current state             *)
(*                 (Idle or Preparing)                                     *)
(*  - workerCustomer: mapping from workers to the customer they're         *)
(*                    serving, or Null if idle                             *)
(***************************************************************************)

vars == <<orderQueue, workerState, workerCustomer>>

TypeOK == 
    /\ orderQueue \in Seq(Customers)
    /\ workerState \in [Workers -> {"Idle", "Preparing"}]
    /\ workerCustomer \in [Workers -> Customers \cup {Null}]

Init ==
    /\ orderQueue = <<>>
    /\ workerState = [w \in Workers |-> "Idle"]
    /\ workerCustomer = [w \in Workers |-> Null]

(* Customer arrives at any time — no guard on global state *)
Arrive(c) ==
    /\ orderQueue' = Append(orderQueue, c)
    /\ UNCHANGED <<workerState, workerCustomer>>

(* Any idle worker picks up the next waiting customer *)
AssignOrder(w) ==
    /\ workerState[w] = "Idle"
    /\ Len(orderQueue) > 0
    /\ workerCustomer' = [workerCustomer EXCEPT ![w] = Head(orderQueue)]
    /\ orderQueue' = Tail(orderQueue)
    /\ workerState' = [workerState EXCEPT ![w] = "Preparing"]

(* Worker finishes serving and becomes idle again *)
CompleteOrder(w) ==
    /\ workerState[w] = "Preparing"
    /\ workerState' = [workerState EXCEPT ![w] = "Idle"]
    /\ workerCustomer' = [workerCustomer EXCEPT ![w] = Null]
    /\ UNCHANGED orderQueue

Next ==
    (\E c \in Customers : Arrive(c))
    \/ (\E w \in Workers : AssignOrder(w))
    \/ (\E w \in Workers : CompleteOrder(w))

(* Safety: Worker state is consistent with workerCustomer assignment *)
Consistency ==
    \A w \in Workers : (workerState[w] = "Idle") => (workerCustomer[w] = Null)

(* Liveness: Every customer in the queue is eventually served *)
EventuallyServed ==
    \A i \in DOMAIN orderQueue : 
        LET c == orderQueue[i] IN
        <> (\E w \in Workers : workerCustomer[w] = c)

Fairness ==
    \A w \in Workers : WF_vars(AssignOrder(w)) /\ WF_vars(CompleteOrder(w))

Spec ==
    Init /\ [][Next]_vars /\ Fairness

(* Theorems *)
THEOREM Spec => []TypeOK
THEOREM Spec => []Consistency

=============================================================================

