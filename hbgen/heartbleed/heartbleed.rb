require 'pp'

pp "Begin to test heartbleed for these hosts"

lines = File.readlines("./heartbleed.host2")
lines.each { |line|
  couple = line.strip.split
  host = couple[0]
  type = couple[1].to_i
  
  if type == 1
    next
  elsif type == 0
    host = "www.#{host}"
  end

  pp "connecting #{host}..."
  res = `python hb-test.py #{host} | tail -n 1`
  pp res
}
