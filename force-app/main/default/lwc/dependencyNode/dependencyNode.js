import { LightningElement, api } from 'lwc';

export default class DependencyNode extends LightningElement {
    @api node;
    @api depth;
    @api nodeSelectionHandler;
    @api fieldTypeChangeHandler;
    @api isNodeSelected;
    @api getNodeFieldType;
    @api generateNodeId;
    @api fieldTypeOptions;

    get nodeId() {
        return this.generateNodeId(this.node.objectName, this.node.fieldName, this.depth);
    }

    get hasChildren() {
        return this.node && this.node.parents && this.node.parents.length > 0;
    }

    get childDepth() {
        return this.depth + 1;
    }

    get isSelected() {
        return this.isNodeSelected(this.nodeId);
    }

    get fieldType() {
        return this.getNodeFieldType(this.nodeId);
    }

    handleNodeSelection = (event) => {
        if (this.nodeSelectionHandler) {
            this.nodeSelectionHandler(event);
        }
    };

    handleFieldTypeChange = (event) => {
        if (this.fieldTypeChangeHandler) {
            this.fieldTypeChangeHandler(event);
        }
    };
}