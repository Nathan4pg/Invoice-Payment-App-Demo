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
// Configure CORS options
const corsOptions = {
    origin: "*",
    credentials: true, // Enable this if you want to allow cookies to be sent with requests
};
// Apply CORS middleware
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
