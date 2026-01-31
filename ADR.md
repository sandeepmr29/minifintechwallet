# Architecture Decision Records (ADR)

This document records key architectural decisions made for the Mini Fintech
Wallet application, along with their trade-offs.

---

## **ADR-001: Use BLoC for State Management**

### Decision
Use the BLoC pattern to manage application state.

### Trade-offs
✅ Predictable, event-driven state changes  
✅ Excellent testability for business logic  
❌ More boilerplate compared to Provider or setState  
❌ Slight learning curve for new developers

---

## **ADR-002: Adopt Clean Architecture (Layered Approach)**

### Decision
Structure the app using Clean Architecture with clear separation between
UI, state management, domain logic, and data layers.

### Trade-offs
✅ Strong separation of concerns  
✅ Easier long-term maintenance and scalability  
❌ Slower initial development  
❌ More files and abstractions

---

## **ADR-003: Offline-First Design with Background Sync**

### Decision
Implement an offline-first approach where transactions are stored locally
and synchronized with the backend when connectivity is available.

### Trade-offs
✅ App remains usable without network  
✅ Better user experience in poor connectivity  
❌ Increased complexity in sync and conflict resolution  
❌ Requires retry and idempotency handling  