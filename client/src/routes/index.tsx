import { createFileRoute } from "@tanstack/react-router";
import { toast } from "sonner";

import { Button } from "@/components/ui/button";
import { logger } from "@/lib/logger";

const Route = createFileRoute("/")({
  component: Index,
});

function Index() {
  return (
    <div className="flex h-screen items-center justify-center">
      <Button
        onClick={() => {
          toast.info("Hello, World!");
          logger.info("Hello, World!");
        }}
      >
        Hello, World!
      </Button>
    </div>
  );
}

export { Route };
