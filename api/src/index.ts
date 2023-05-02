import express from "express";
import cors from "cors";
import { ApolloServer } from "apollo-server-express";
import { typeDefs, resolvers } from "./schema";

const app = express();

// Configure CORS options
const corsOptions = {
  origin: "*", // You can specify your allowed origins here, e.g., "http://localhost:3000"
  credentials: true, // Enable this if you want to allow cookies to be sent with requests
};

// Apply CORS middleware
app.use(cors(corsOptions));

const server = new ApolloServer({
  typeDefs,
  resolvers,
});

server
  .start()
  .then(() => {
    server.applyMiddleware({ app });
  })
  .catch((e) => console.log("Error: ", e));

const port = process.env.PORT || 4000;

app.listen(port, () => {
  console.log(
    `🚀 Server ready at http://localhost:${port}${server.graphqlPath}`
  );
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
