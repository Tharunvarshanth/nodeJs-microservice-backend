import { Router } from "express";
const router = Router();
import { getUsers } from "../controller/controller";

router.get("/", getUsers);
export default router;
