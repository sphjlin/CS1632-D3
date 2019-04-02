# Sophia Lin(sjl81)
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index 
end

ts = true
fs = false
post '/truth_table' do
  puts "Start displsy."
  ts = params['truth_symbol'].to_s
  fs = params['false_symbol'].to_s
  size = params['size'].to_s

# set to default if input is nothing
  ts = "T" if ts == ""
  fs = "F" if fs == ""
  size = "3" if size == ""
  size = size.to_i

  puts params
  if symbols_invalid(ts, fs, size)
    puts "Symbols invalid."
    erb :invalid_parameters
  else
    puts "Symbols valid."
    erb :truth_table, :locals => { ts: ts, fs: fs, size: size}
  end
end

#error Sinatra::NotFound do
#  erb :invalid_address
#end

not_found do
  status 404
  erb :invalid_address
end


#-------------------------------------------------
def calculate_total_ts(truth_table, row, ts, size)
  total_num_of_ts = 0
  (0...size).each do |n|
    if truth_table[row][n] == true
      total_num_of_ts += 1
    end
  end
  total_num_of_ts
end
def calculate_total_fs(truth_table, row, fs, size)
  total_num_of_fs = 0
  (0...size).each do |n|
    if truth_table[row][n] == false
      total_num_of_fs += 1
    end
  end
  total_num_of_fs
end

#-------------------------------------------------
def AND(ts, fs, total_num_of_ts, total_num_of_fs)
  val = ts
  if total_num_of_fs > 0
    val = fs
  end
  val
end

def OR(ts, fs, total_num_of_ts, total_num_of_fs)
  val = fs
  if total_num_of_ts > 0
    val = ts
  end
  val
end

def NAND(ts, fs, total_num_of_ts, total_num_of_fs)
  if AND(ts, fs, total_num_of_ts, total_num_of_fs) == ts
    val = fs 
  else
   val = ts
  end
  val
end

def NOR(ts, fs, total_num_of_ts, total_num_of_fs)
  if OR(ts, fs, total_num_of_ts, total_num_of_fs) == ts
    val = fs 
  else
    val = ts
  end
  val
end

def XOR(ts, fs, total_num_of_ts, total_num_of_fs)
  val = ts
  # if even number, false
  if total_num_of_ts % 2 == 0
    val = fs
  end
  val
end

def SINGLE(ts, fs, total_num_of_ts, total_num_of_fs)
  val = fs
  if total_num_of_ts == 1
    val = ts
  end
  val
end
#-------------------------------------------------

def symbols_invalid(ts, fs, size)
  if (ts.length > 1) ||
     (fs.length > 1) ||
     (size < 2) ||
     (ts.eql?(fs))
    to_return = true
  else
    to_return = false
  end
end

def const_table(ts, fs, size)
  to_return =[fs, ts]
  to_return.repeated_permutation(size).to_a
end
