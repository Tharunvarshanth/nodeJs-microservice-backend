import { Router } from "express";
const router = Router();
import { getUsers } from "./controller";

router.get("/", getUsers);
export default router;
