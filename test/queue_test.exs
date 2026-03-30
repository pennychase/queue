defmodule QueueTest do
  use ExUnit.Case
  use ExUnitProperties
  import StreamData
  doctest Queue

  test "creates a new empty queue" do
    queue = Queue.new()
    assert Queue.empty?(queue) == true
    assert Queue.size(queue) == 0
  end

  test "peek returns nil for empty queue" do
    queue = Queue.new()
    assert Queue.peek(queue) == nil
  end

  test "single item enqueue and dequeue" do
    queue = Queue.new()
    |> Queue.enqueue(:single)
    {item, new_queue} = Queue.dequeue(queue)
    assert item == :single
    assert Queue.empty?(new_queue) == true
  end

  test "enqueues and dequeues items" do
    queue = Queue.new()
    queue = Queue.enqueue(queue, 1)
    queue = Queue.enqueue(queue, 2)
    queue = Queue.enqueue(queue, 3)

    assert Queue.size(queue) == 3
    assert Queue.peek(queue) == 1

    {item, queue} = Queue.dequeue(queue)
    assert item == 1
    assert Queue.size(queue) == 2
    assert Queue.peek(queue) == 2

    {item, queue} = Queue.dequeue(queue)
    assert item == 2
    assert Queue.size(queue) == 1
    assert Queue.peek(queue) == 3

    {item, queue} = Queue.dequeue(queue)
    assert item == 3
    assert Queue.empty?(queue) == true
  end

  test "dequeue from an empty queue" do
    queue = Queue.new()
    {item, queue} = Queue.dequeue(queue)
    assert item == nil
    assert Queue.empty?(queue) == true
  end

  test "enqueue returns new queue without mutating original" do
    queue1 = Queue.new()
    queue2 = Queue.enqueue(queue1, :item)
    assert Queue.empty?(queue1) == true
    assert Queue.size(queue2) == 1
  end

  property "enqueue increases size by 1" do
    check all items <- list_of(integer()) do
      queue = Enum.reduce(items, Queue.new(), &Queue.enqueue(&2, &1))

      new_queue = Queue.enqueue(queue, 0)
      assert Queue.size(new_queue) == Queue.size(queue) + 1
    end
  end

  property "dequeue decreases size by 1 until empty" do
    check all items <- list_of(integer(), min_length: 1) do
      queue = Enum.reduce(items, Queue.new(), &Queue.enqueue(&2, &1))
      initial_size = Queue.size(queue)

      {_item, new_queue} = Queue.dequeue(queue)
      assert Queue.size(new_queue) == initial_size - 1
    end
  end

  property "size matches number of enqueued items" do
    check all items <- list_of(integer()) do
      queue = Enum.reduce(items, Queue.new(), &Queue.enqueue(&2, &1))
      assert Queue.size(queue) == length(items)
    end
  end

  property "FIFO order is maintained" do
    check all items <- list_of(integer()) do
      queue = Enum.reduce(items, Queue.new(), &Queue.enqueue(&2, &1))

      dequeued_items = Enum.reduce(1..length(items), {[], queue}, fn _, {acc, q} ->
        case Queue.dequeue(q) do
          {nil, _} -> {acc, q}
          {item, new_q} -> {[item | acc], new_q}
        end
      end) |> elem(0) |> Enum.reverse()

      assert dequeued_items == items
    end
  end

end
