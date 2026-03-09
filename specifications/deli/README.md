# Deli

A TLA⁺ specification of a simple deli ordering system with a bounded ticket-queue model.

The spec models customers arriving and being served sequentially. Customers arrive (bounded by `MaxArrivals`), receive a ticket number, join an order queue, get assigned to a worker, receive service, and the system resets to serve the next customer. The system cycles through states: Idle → TakingOrder → PreparingOrder → Serving → ReturnToIdle.

## Design

- **Ticket-based ordering**: Customers get monotonically increasing ticket numbers as they arrive
- **Queue discipline**: Customers are served in FIFO order from the queue
- **Bounded arrivals**: The `MaxArrivals` constant limits customer arrivals for tractable model checking
- **State machine with return cycle**: The system explicitly cycles back to Idle after each service, preventing deadlock and allowing new orders

## Properties Verified

The specification includes three safety invariants, all verified by TLC:

1. **TypeOK**: State variables maintain correct types throughout execution
2. **ValidStates**: The system never enters an undefined state
3. **MutualExclusion**: At most one customer is being served at any time; idle workers cannot be assigned

The `.tla` file includes formal THEOREM declarations for each property. With `MaxArrivals = 2` and `Processes = {p1, p2, p3}`, the model contains **30 distinct states** and completes exhaustive model checking in under 1 second.
