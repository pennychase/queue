defmodule Queue do
  @moduledoc """
  Documentation for `Queue`.
  """
  defstruct [:items]

  @doc """
  Creates a new empty queue.
  """
  def new() do
    %Queue{items: []}
  end

  @doc """
  Enqueues an item into the queue.
  """
  def enqueue(queue, item) do
    %Queue{items: queue.items ++ [item]}
  end


  @spec dequeue(any()) :: {any(), any()}
  @doc """
  Dequeues an item from the queue. Returns a tuple of the dequeued item and the updated queue.
  """
  def dequeue(queue) do
    case queue.items do
      [] ->
        {nil, queue}
      [head | tail] ->
        {head, %Queue{items: tail}}
    end
  end

  @doc """
  Checks if the queue is empty.
  """
  def empty?(queue) do
    Enum.empty?(queue.items)
  end

  @doc """
  Returns the number of items in the queue.
  """
  def size(queue) do
    length(queue.items)
  end

  @doc """
  Returns the item at the front of the queue without removing it.
  """
  def peek(queue) do
    case queue.items do
      [] -> nil
      [head | _] -> head
    end
  end


end
