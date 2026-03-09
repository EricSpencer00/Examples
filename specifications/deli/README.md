# Deli

A TLA⁺ specification of a simple deli ordering system with a bounded ticket-queue model.

The spec models customers arriving and being served sequentially. Customers arrive (bounded by `MaxArrivals`), receive a ticket number, join an order queue, get assigned to a worker, receive service, and the system resets to serve the next customer. The system progresses through four states: Idle, TakingOrder, PreparingOrder, and Serving; transitions include ReturnToIdle which moves from Serving back to Idle.

## Design

- **Bounded arrivals**: The `MaxArrivals` constant limits customer arrivals for tractable model checking
- **Queue discipline**: Customers join the orderQueue in FIFO order
- **Worker assignment**: Any available worker processes the next customer from the queue
- **Cyclic state machine**: The system explicitly cycles back to Idle after each service, preventing deadlock

## Properties Verified

The specification includes three safety invariants, all verified by TLC:

1. **TypeOK**: All state variables maintain their declared types throughout execution
2. **ValidStates**: The system's state variable remains one of the four allowed values
3. **ConsistentIdle**: When in the Idle state, no customer or worker is assigned

With `MaxArrivals = 2` and `Processes = {p1, p2, p3}`, the model contains **45 distinct states** and completes exhaustive model checking in under 1 second.
