--create a new set called parking
redis.call('del','parking')
print('Restarted...')

for i=0, 98, 1
do
  redis.call('rpush','parking','vacant')
end

local number_of_parking_spots = redis.call('llen','parking')

--if there are vacant spots add a plane to the first one you find
local function add_to_parking(airplane_id)
  for i=0,number_of_parking_spots,1
  do
    if redis.call('lindex','parking',i) == 'vacant' then
      redis.call('lset','parking', i,airplane_id)
      return i+1
    end
  end
  return -1
end

--not required but a useful thing to have regardless
local function remove_from_parking(airplane_id)
  for i=0,number_of_parking_spots,1
  do
    if redis.call('lindex','parking',i) == ''..airplane_id then
      redis.call('lset','parking',i,'vacant')
      return i+1
    end
  end
  return -1
end


--[[if an airplane_id is not in parking add it,
  if it is return the id,
  otherwise the parking is full]]
local function check_parking(airplane_id)
  for i=0,number_of_parking_spots,1
  do
    if redis.call('lindex','parking',i) == ''..airplane_id then
      return i+1
    end
  end

  local parking_space_id = add_to_parking(airplane_id)

  if parking_space_id ~= -1 then
    return parking_space_id

  end
  return -1
end

--fill the parking spaces with some random airplane_ids 1-80
for i=0,number_of_parking_spots-1,1
do
print(check_parking((math.ceil(math.random()*10000))%79+1))
end

--[[example tests of functions
print(check_parking(80))
print(remove_from_parking(23))]]