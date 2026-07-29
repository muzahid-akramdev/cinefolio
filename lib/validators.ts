import { z } from 'zod'
export const reviewSchema = z.object({
  rating: z.number().min(1).max(10),
  body: z.string().min(10).max(5000),
  has_spoilers: z.boolean().default(false),
})
