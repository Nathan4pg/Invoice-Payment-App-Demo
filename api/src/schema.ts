import gql from "graphql-tag";
import { faker } from "@faker-js/faker";
import { DocumentNode } from "graphql";

enum SortByEnum {
  DUE_DATE_ASC = "DUE_DATE_ASC",
  DUE_DATE_DESC = "DUE_DATE_DESC",
}

enum SortDirectionEnum {
  ASC = "ASC",
  DESC = "DESC",
}

interface Invoice {
  id: string;
  amount: string;
  paid: boolean;
  dueDate: Date;
  paidDate: Date | null;
  grossAmount: string;
  invoicedDate: Date;
  orderNumber: string;
  deliveryDate: Date;
  salesRepresentative: string;
  shippingCompany: string;
  shipmentTrackingId: string;
}

const invoices: Invoice[] = [];

// Generate invoices with unique IDs
for (let i = 0; i < 100; i++) {
  const amount: string = faker.finance.amount(1000, 5000, 2, "$");
  const paid: boolean = faker.datatype.boolean();
  const grossAmount: string = faker.finance.amount(1000, 5000, 2, "$");
  const invoicedDate: Date = faker.date.past(30);
  const orderNumber: string = `ORD-${faker.datatype.number(9999)}`;
  const deliveryDate: Date = faker.date.future(30);
  const salesRepresentative: string = `${faker.name.firstName()} ${faker.name.lastName()}`;
  const shippingCompanies: string[] = ["UPS", "FedEx", "USPS", "DHL"];
  const shippingCompany: string =
    shippingCompanies[Math.floor(Math.random() * shippingCompanies.length)];
  const shipmentTrackingId: string = `TRACK-${faker.random.alphaNumeric(8)}`;

  invoices.push({
    id: faker.random.alphaNumeric(16).toUpperCase(), // Use a unique value for each invoice
    amount: amount,
    paid: paid,
    dueDate: faker.date.future(30),
    paidDate: paid ? faker.date.past(30) : null,
    grossAmount: grossAmount,
    invoicedDate: invoicedDate,
    orderNumber: orderNumber,
    deliveryDate: deliveryDate,
    salesRepresentative: salesRepresentative,
    shippingCompany: shippingCompany,
    shipmentTrackingId: shipmentTrackingId,
  });
}

export const typeDefs: DocumentNode = gql`
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

interface InvoicesConnection {
  edges: InvoiceEdge[];
  pageInfo: PageInfo;
}

interface InvoiceEdge {
  cursor: string;
  node: Invoice;
}

interface PageInfo {
  hasNextPage: boolean;
  endCursor?: string;
}

export const resolvers = {
  Query: {
    invoices: (
      _: unknown,
      {
        first,
        after,
        sortBy,
        sortDirection,
      }: {
        first?: number;
        after?: string;
        sortBy: SortByEnum;
        sortDirection: SortDirectionEnum;
      }
    ): InvoicesConnection => {
      let sortedInvoices = invoices.slice();

      if (sortBy === SortByEnum.DUE_DATE_ASC) {
        sortedInvoices.sort((a, b) => (a.dueDate > b.dueDate ? 1 : -1));
      } else if (sortBy === SortByEnum.DUE_DATE_DESC) {
        sortedInvoices.sort((a, b) => (a.dueDate < b.dueDate ? 1 : -1));
      }

      if (sortDirection === SortDirectionEnum.DESC) {
        sortedInvoices.reverse();
      }

      let edges: InvoiceEdge[] = [];
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
      const pageInfo: PageInfo = {
        hasNextPage: endIndex < sortedInvoices.length,
        endCursor:
          edges.length > 0 ? edges[edges.length - 1].cursor : undefined,
      };
      return {
        edges,
        pageInfo,
      };
    },
  },
  Mutation: {
    markInvoicePaid: (_: unknown, { id }: { id: string }): Invoice => {
      const invoice = invoices.find((invoice: Invoice) => invoice.id === id);
      if (!invoice) {
        throw new Error(`Invoice with ID ${id} not found`);
      }
      invoice.paid = true;
      return invoice;
    },
  },
};
