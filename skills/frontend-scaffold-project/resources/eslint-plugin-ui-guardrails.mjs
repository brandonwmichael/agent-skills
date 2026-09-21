// eslint-plugin-ui-guardrails.mjs
export const uiGuardrailsPlugin = {
  meta: {
    name: "eslint-plugin-ui-guardrails",
    version: "1.0.0",
  },
  rules: {
    "ban-raw-html-primitives": {
      meta: {
        type: "problem",
        docs: {
          description: "Ban raw interactive HTML elements outside src/components/ui",
        },
        schema: [],
        messages: {
          bannedTag:
            "Raw <{{tag}}> is prohibited. Import the standardized design token primitive from '@/components/ui/{{component}}' instead.",
        },
      },
      create(context) {
        const filename = context.filename || context.getFilename();
        // Allow raw HTML elements only inside the primitive definitions themselves
        if (filename.includes("components/ui/") || filename.includes("components\\ui\\")) {
          return {};
        }

        const tagMap = {
          button: "Button",
          input: "Input",
          select: "Select",
          textarea: "Textarea",
        };

        return {
          JSXOpeningElement(node) {
            if (node.name.type === "JSXIdentifier" && tagMap[node.name.name]) {
              const tag = node.name.name;
              context.report({
                node,
                messageId: "bannedTag",
                data: {
                  tag,
                  component: tag.charAt(0).toUpperCase() + tag.slice(1),
                },
              });
            }
          },
        };
      },
    },

    "enforce-compound-subcomponents": {
      meta: {
        type: "suggestion",
        docs: {
          description: "Enforce compound component dot-notation (e.g., <Card.Header> instead of <CardHeader>)",
        },
        schema: [],
        messages: {
          preferCompound:
            "Direct usage of flat subcomponent '<{{name}}>' is prohibited. Use the compound dot-notation '<{{parent}}.{{child}}>' instead.",
        },
      },
      create(context) {
        // List of components that must be consumed via dot-notation namespaces
        const compoundMappings = {
          CardHeader: { parent: "Card", child: "Header" },
          CardTitle: { parent: "Card", child: "Title" },
          CardContent: { parent: "Card", child: "Content" },
          CardFooter: { parent: "Card", child: "Footer" },
          DialogTrigger: { parent: "Dialog", child: "Trigger" },
          DialogContent: { parent: "Dialog", child: "Content" },
          DialogHeader: { parent: "Dialog", child: "Header" },
          DialogTitle: { parent: "Dialog", child: "Title" },
        };

        return {
          JSXOpeningElement(node) {
            if (
              node.name.type === "JSXIdentifier" &&
              compoundMappings[node.name.name]
            ) {
              const mapping = compoundMappings[node.name.name];
              context.report({
                node,
                messageId: "preferCompound",
                data: {
                  name: node.name.name,
                  parent: mapping.parent,
                  child: mapping.child,
                },
              });
            }
          },
        };
      },
    },
  },
};
