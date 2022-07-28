import { Router } from "express";
const router = Router();
import { getOrders } from "../controller/controller";

router.get("/", getOrders);
export default router;
