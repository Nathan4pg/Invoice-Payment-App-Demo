import { WebSocketLink } from "@apollo/client/link/ws";
import { SubscriptionClient } from "subscriptions-transport-ws";
const link = new WebSocketLink(new SubscriptionClient("ws://localhost:4000/graphql", {
    reconnect: true,
}));
