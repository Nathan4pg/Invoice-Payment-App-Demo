"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const apollo_server_express_1 = require("apollo-server-express");
const schema_1 = require("./schema");
const app = (0, express_1.default)();
const corsOptions = {
    origin: "*",
    credentials: true,
};
app.use((0, cors_1.default)(corsOptions));
const server = new apollo_server_express_1.ApolloServer({
    typeDefs: schema_1.typeDefs,
    resolvers: schema_1.resolvers,
});
server
    .start()
    .then(() => {
    server.applyMiddleware({ app });
})
    .catch((e) => console.log("Error: ", e));
const port = process.env.PORT || 4000;
app.listen(port, () => {
    console.log(`🚀 Server ready at http://localhost:${port}${server.graphqlPath}`);
});
/**
 * Example Query:

 query GetInvoices($first: Int, $after: ID, $sortBy: SortByEnum = DUE_DATE_ASC, $sortDirection: SortDirectionEnum = ASC) {
  invoices(first: $first, after: $after, sortBy: $sortBy, sortDirection: $sortDirection) {
    edges {
      cursor
      node {
        id
        amount
        paid
        dueDate
        paidDate
        grossAmount
        invoicedDate
        orderNumber
        deliveryDate
        salesRepresentative
        shippingCompany
        shipmentTrackingId
      }
    }
    pageInfo {
      hasNextPage
      endCursor
    }
  }
}

* Variables:

{
  "first": 10,
  "sortBy": "DUE_DATE_DESC",
  "after": null,
  "sortDirection": "DESC"
}
 
 */
