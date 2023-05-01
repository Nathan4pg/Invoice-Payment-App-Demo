"use strict";
var __importDefault =
  (this && this.__importDefault) ||
  function (mod) {
    return mod && mod.__esModule ? mod : { default: mod };
  };
Object.defineProperty(exports, "__esModule", { value: true });
exports.resolvers = exports.typeDefs = void 0;
const graphql_tag_1 = __importDefault(require("graphql-tag"));
const faker_1 = require("@faker-js/faker");
var SortByEnum;
(function (SortByEnum) {
  SortByEnum["DUE_DATE_ASC"] = "DUE_DATE_ASC";
  SortByEnum["DUE_DATE_DESC"] = "DUE_DATE_DESC";
})(SortByEnum || (SortByEnum = {}));
var SortDirectionEnum;
(function (SortDirectionEnum) {
  SortDirectionEnum["ASC"] = "ASC";
  SortDirectionEnum["DESC"] = "DESC";
})(SortDirectionEnum || (SortDirectionEnum = {}));
const invoices = [];
// Generate invoices with unique IDs
for (let i = 0; i < 100; i++) {
  const amount = faker_1.faker.finance.amount(1000, 5000, 2, "$");
  const paid = faker_1.faker.datatype.boolean();
  const grossAmount = faker_1.faker.finance.amount(1000, 5000, 2, "$");
  const invoicedDate = faker_1.faker.date.past(30);
  const orderNumber = `ORD-${faker_1.faker.datatype.number(9999)}`;
  const deliveryDate = faker_1.faker.date.future(30);
  const salesRepresentative = `${faker_1.faker.name.firstName()} ${faker_1.faker.name.lastName()}`;
  const shippingCompanies = ["UPS", "FedEx", "USPS", "DHL"];
  const shippingCompany =
    shippingCompanies[Math.floor(Math.random() * shippingCompanies.length)];
  const shipmentTrackingId = `TRACK-${faker_1.faker.random.alphaNumeric(8)}`;
  invoices.push({
    id: faker_1.faker.random.alphaNumeric(16).toUpperCase(),
    amount: amount,
    paid: paid,
    dueDate: faker_1.faker.date.future(30),
    paidDate: paid ? faker_1.faker.date.past(30) : null,
    grossAmount: grossAmount,
    invoicedDate: invoicedDate,
    orderNumber: orderNumber,
    deliveryDate: deliveryDate,
    salesRepresentative: salesRepresentative,
    shippingCompany: shippingCompany,
    shipmentTrackingId: shipmentTrackingId,
  });
}
exports.typeDefs = (0, graphql_tag_1.default)`
  type Invoice {
    id: ID!
    amount: String!
    paid: Boolean!
    "The due date of the invoice"
    dueDate: String!
    "The date the invoice was paid (if paid)"
    paidDate: String
    "The gross amount of the invoice"
    grossAmount: String!
    "The date the invoice was generated"
    invoicedDate: String!
    "The order number associated with the invoice"
    orderNumber: String!
    "The date the order was delivered"
    deliveryDate: String!
    "The name of the sales representative for the order"
    salesRepresentative: String!
    "The name of the shipping company for the order"
    shippingCompany: String!
    "The tracking ID for the shipment"
    shipmentTrackingId: String!
  }

  enum SortByEnum {
    DUE_DATE_ASC
    DUE_DATE_DESC
  }

  enum SortDirectionEnum {
    ASC
    DESC
  }

  type Query {
    invoices(
      first: Int
      after: ID
      sortBy: SortByEnum = DUE_DATE_ASC
      sortDirection: SortDirectionEnum = ASC
    ): InvoicesConnection!
  }

  type InvoicesConnection {
    edges: [InvoiceEdge!]!
    pageInfo: PageInfo!
  }

  type InvoiceEdge {
    cursor: ID!
    node: Invoice!
  }

  type PageInfo {
    hasNextPage: Boolean!
    endCursor: ID
  }

  type Mutation {
    markInvoicePaid(id: ID!): Invoice!
  }
`;
exports.resolvers = {
  Query: {
    invoices: (_, { first, after, sortBy, sortDirection }) => {
      console.log("Query: invoices"); // Log when the query is hit
      let sortedInvoices = invoices.slice();
      if (sortBy === SortByEnum.DUE_DATE_ASC) {
        sortedInvoices.sort((a, b) => (a.dueDate > b.dueDate ? 1 : -1));
      } else if (sortBy === SortByEnum.DUE_DATE_DESC) {
        sortedInvoices.sort((a, b) => (a.dueDate < b.dueDate ? 1 : -1));
      }
      if (sortDirection === SortDirectionEnum.DESC) {
        sortedInvoices.reverse();
      }
      let edges = [];
      let startIndex = 0;
      let endIndex = sortedInvoices.length;
      if (first) {
        endIndex = Math.min(endIndex, startIndex + first);
      }
      if (after) {
        const cursorIndex = sortedInvoices.findIndex(
          (invoice) => invoice.id === after
        );
        if (cursorIndex !== -1) {
          startIndex = cursorIndex + 1;
        }
      }
      edges = sortedInvoices.slice(startIndex, endIndex).map((invoice) => ({
        cursor: invoice.id,
        node: {
          ...invoice,
          id: `${invoice.id}`,
        },
      }));
      const pageInfo = {
        hasNextPage: endIndex < sortedInvoices.length,
        endCursor:
          edges.length > 0 ? edges[edges.length - 1].cursor : undefined,
      };
      console.log("Response:", { edges, pageInfo }); // Log the response
      return {
        edges,
        pageInfo,
      };
    },
  },
  Mutation: {
    markInvoicePaid: (_, { id }) => {
      const invoice = invoices.find((invoice) => invoice.id === id);
      if (!invoice) {
        throw new Error(`Invoice with ID ${id} not found`);
      }
      invoice.paid = true;
      return invoice;
    },
  },
};
