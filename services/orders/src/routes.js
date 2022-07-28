import { Router } from "express";
const router = Router();
import { getOrders } from "./controller";

router.get("/", getOrders);
export default router;
