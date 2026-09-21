# UI Structural Design Patterns Reference

This reference documents the mandatory architectural patterns for synthesizing UI components in this repository.

---

## 1. Compound Component Pattern with Dot-Notation

Avoid monolithic components with dozens of optional props. For components with interdependent layout or state (Cards, Modals, Menus, Accordions), build composable subcomponents grouped under a parent namespace.

### Implementation Pattern
```tsx
// src/components/ui/card.tsx
import * as React from "react";
import { cn } from "@/lib/utils";

const CardRoot = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn("rounded-lg border bg-card text-card-foreground shadow-sm", className)} {...props} />
  )
);
CardRoot.displayName = "Card";

const CardHeader = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn("flex flex-col space-y-1.5 p-6", className)} {...props} />
  )
);
CardHeader.displayName = "Card.Header";

const CardTitle = React.forwardRef<HTMLParagraphElement, React.HTMLAttributes<HTMLHeadingElement>>(
  ({ className, ...props }, ref) => (
    <h3 ref={ref} className={cn("text-2xl font-semibold leading-none tracking-tight", className)} {...props} />
  )
);
CardTitle.displayName = "Card.Title";

const CardContent = React.forwardRef<HTMLDivElement, React.HTMLAttributes<HTMLDivElement>>(
  ({ className, ...props }, ref) => (
    <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
  )
);
CardContent.displayName = "Card.Content";

export const Card = Object.assign(CardRoot, {
  Header: CardHeader,
  Title: CardTitle,
  Content: CardContent,
});
```

### Consumption Pattern (Enforced by AST Linter)
```tsx
// Correct (Dot-Notation)
<Card data-testid="metrics-card">
  <Card.Header>
    <Card.Title>Metrics</Card.Title>
  </Card.Header>
  <Card.Content>
    <p>Content</p>
  </Card.Content>
</Card>

// PROHIBITED (Will trigger ESLint error ui-guardrails/enforce-compound-subcomponents):
// <CardHeader><CardTitle>Metrics</CardTitle></CardHeader>
```

---

## 2. Container / Presentational Split (Logic Hooks)

Separate data retrieval, API mutations, and side-effects from visual layout templates:
1. **Logic Hook (`use[Feature]Data.ts`):** Handles state management, fetching, validation, and callbacks.
2. **Presentational Component (`[Feature].tsx`):** Pure declarative template receiving typed props or consuming the hook cleanly.

### Example Logic Hook
```ts
// src/lib/hooks/useMetrics.ts
import { useState, useEffect } from "react";

export interface MetricItem {
  id: string;
  label: string;
  value: number;
}

export function useMetrics() {
  const [data, setData] = useState<MetricItem[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Data retrieval logic
    fetch("/api/metrics")
      .then((res) => res.json())
      .then((items: MetricItem[]) => {
        setData(items);
        setLoading(false);
      });
  }, []);

  return { data, loading };
}
```

### Example Presentational View
```tsx
// src/components/features/MetricsView.tsx
import * as React from "react";
import { Card } from "@/components/ui/card";
import { useMetrics } from "@/lib/hooks/useMetrics";

export function MetricsView() {
  const { data, loading } = useMetrics();

  if (loading) return <div data-testid="metrics-loading">Loading...</div>;

  return (
    <div className="grid gap-4 md:grid-cols-2" data-testid="metrics-container">
      {data.map((item) => (
        <Card key={item.id} data-testid={`metric-card-${item.id}`}>
          <Card.Header>
            <Card.Title>{item.label}</Card.Title>
          </Card.Header>
          <Card.Content>
            <span className="text-2xl font-bold">{item.value}</span>
          </Card.Content>
        </Card>
      ))}
    </div>
  );
}
```

---

## 3. Polymorphic / Slot Pattern (`asChild`)

Use Radix UI `Slot` to delegate rendering to child elements without creating extra DOM wrapper divs:

```tsx
import * as React from "react";
import { Slot } from "@radix-ui/react-slot";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const buttonVariants = cva("inline-flex items-center justify-center font-medium ...", {
  variants: {
    variant: {
      default: "bg-primary text-primary-foreground hover:bg-primary/90",
      outline: "border border-input bg-background hover:bg-accent",
    },
    size: {
      default: "h-10 px-4 py-2",
      sm: "h-9 rounded-md px-3",
    },
  },
  defaultVariants: {
    variant: "default",
    size: "default",
  },
});

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button";
    return <Comp className={cn(buttonVariants({ variant, size, className }))} ref={ref} {...props} />;
  }
);
Button.displayName = "Button";
```

---

## 4. Class Variance Authority (`cva`) for Variant Typing

- **Never** inject ad-hoc Tailwind arbitrary classes for states (e.g. `bg-[#1a2b3c] text-[13px]`).
- Define all variant dimensions (e.g. `variant`, `size`, `intent`) using `cva`.
- Export variant types using `VariantProps<typeof componentVariants>`.

---

## 5. File Size Ceiling (Max 180 Lines)

- ESLint `max-lines` is configured to throw a hard error at 180 lines.
- If a component exceeds 180 lines, extract internal subcomponents into separate files or extract state/effects into a custom hook.
