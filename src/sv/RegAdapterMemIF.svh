/**
 * RegAdapterMemIF.svh
 *
 * Copyright 2024 Matthew Ballance and Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may 
 * not use this file except in compliance with the License.  
 * You may obtain a copy of the License at:
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS, 
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  
 * See the License for the specific language governing permissions and 
 * limitations under the License.
 *
 * Created on:
 *     Author: 
 */
class RegAdapterMemIF #(type BASE_IF=uvm_object) extends BASE_IF;
    uvm_reg_adapter         m_reg_adapter;
    uvm_sequencer_base      m_reg_seqr;
    uvm_sequence_base       m_seq;

    // Default sequence used if a custom sequence isn't supplied
    class default_reg_seq extends uvm_sequence_base;
        `uvm_object_utils(default_reg_seq)
        function new(string name="");
            super.new(name);
        endfunction
    endclass

    function new(string name="");
        super.new(name);
    endfunction

    virtual task read8(
        output byte unsigned        retval,
        input longint unsigned      hndl);
        uvm_reg_bus_op op;
        op.kind = UVM_READ;
        op.addr = hndl;
        op.n_bits = 8;
        access(op);
        retval = op.data;
    endtask

    virtual task read16(
        output shortint unsigned    retval,
        input longint unsigned      hndl);
        uvm_reg_bus_op op;
        op.kind = UVM_READ;
        op.addr = hndl;
        op.n_bits = 16;
        access(op);
        retval = op.data;
    endtask

    virtual task read32(
        output int unsigned         retval,
        input longint unsigned      hndl);
        uvm_reg_bus_op op;
        op.kind = UVM_READ;
        op.addr = hndl;
        op.n_bits = 32;
        access(op);
        retval = op.data;
    endtask

    virtual task read64(
        output longint unsigned     retval,
        input longint unsigned      hndl);
        uvm_reg_bus_op op;
        op.kind = UVM_READ;
        op.addr = hndl;
        op.n_bits = 64;
        access(op);
        retval = op.data;
    endtask

    virtual task write8(
        input longint unsigned      hndl,
        input byte unsigned         data);
        uvm_reg_bus_op op;
        op.kind = UVM_WRITE;
        op.addr = hndl;
        op.data = data;
        op.n_bits = 8;
        access(op);
    endtask

    virtual task write16(
        input longint unsigned      hndl,
        input shortint unsigned     data);
        uvm_reg_bus_op op;
        op.kind = UVM_WRITE;
        op.addr = hndl;
        op.data = data;
        op.n_bits = 16;
        access(op);
    endtask

    virtual task write32(
        input longint unsigned      hndl,
        input int unsigned          data);
        uvm_reg_bus_op op;
        op.kind = UVM_WRITE;
        op.addr = hndl;
        op.data = data;
        op.n_bits = 32;
        access(op);
    endtask

    virtual task write64(
        input longint unsigned      hndl,
        input longint unsigned      data);
        uvm_reg_bus_op op;
        op.kind = UVM_WRITE;
        op.addr = hndl;
        op.data = data;
        op.n_bits = 64;
        access(op);
    endtask

    task access(ref uvm_reg_bus_op op);
        if (m_reg_adapter == null) begin
            `uvm_fatal(get_name(), "RegAdapterMemIF: m_reg_adapter not specified");
            return;
        end
        if (m_reg_seqr == null) begin
            `uvm_fatal(get_name(), "RegAdapterMemIF: m_reg_seqr not specified");
            return;
        end
        if (m_seq == null) begin
            m_seq = default_reg_seq::type_id::create();
        end

        // Create a sequence item
        begin
            uvm_sequence_item item;

            item = m_reg_adapter.reg2bus(op);
            m_seq.set_sequencer(m_reg_seqr);
            item.set_parent_sequence(m_seq);
            m_seq.start_item(item);
            m_seq.finish_item(item);

            if (op.kind == UVM_READ) begin
                m_reg_adapter.bus2reg(item, op);
            end
        end
    endtask

endclass

