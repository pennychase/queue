defmodule QueueTest do
  use ExUnit.Case
  doctest Queue

  test "creates a new empty queue" do
    queue = Queue.new()
    assert Queue.empty?(queue) == true
    assert Queue.size(queue) == 0
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
end
