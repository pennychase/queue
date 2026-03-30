defmodule Queue do
  @moduledoc """
  Documentation for `Queue`.

  ## Internal Structure

    - `inbox`: a list efficient for enqueueing items (new items are added to the head).
    - `outbox`: a list efficient for dequeueing items (items are removed from the head). When `outbox` is empty, we reverse `inbox` into `outbox`.
  """
  defstruct inbox: [], outbox: []

  @doc """
  Creates a new empty queue.
  """
  def new() do
    %Queue{inbox: [], outbox: []}
  end

  @doc """
  Enqueues an item into the queue. Do this efficiently
  """
  def enqueue(queue, item) do
    %Queue{inbox: [item | queue.inbox], outbox: queue.outbox}
  end

  @spec dequeue(any()) :: {any(), any()}
  @doc """
  Dequeues an item from the queue. Returns a tuple of the dequeued item and the updated queue.
  Checks if the outbox is empty; if it is, it reverses the inbox into the outbox before dequeuing.

  """
  def dequeue(%Queue{inbox: inbox, outbox: []}) do
    case Enum.reverse(inbox) do
      [] -> {nil, %Queue{inbox: [], outbox: []}}
      [head | tail] -> {head, %Queue{inbox: [], outbox: tail}}
    end
  end

  def dequeue(%Queue{inbox: inbox, outbox: [head | tail]}) do
    {head, %Queue{inbox: inbox, outbox: tail}}
  end

  @doc """
  Checks if the queue is empty.
  """
  def empty?(queue) do
    Enum.empty?(queue.inbox) and Enum.empty?(queue.outbox)
  end

  @doc """
  Returns the number of items in the queue.
  """
  def size(queue) do
    length(queue.inbox) + length(queue.outbox)
  end

  @doc """
  Returns the item at the front of the queue without removing it.
  """
  def peek(%Queue{inbox: inbox, outbox: []}) do
    case Enum.reverse(inbox) do
      [] -> nil
      [head | _] -> head
    end
  end

  def peek(%Queue{inbox: _inbox, outbox: [head | _tail]}), do: head

end
