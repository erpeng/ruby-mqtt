class MQTT::Redis


  def initialize(rety_time)
    require 'redis'
    @redis=Redis.new
    @time=Time.now.to_i
    @retry_time=rety_time
  end

  def save(packet,client_id)
    #if client_id.nil?
    #  client_id=''
    #end
    @redis.pipelined do
      @redis.zadd "mqtt-publish",@time,client_id+packet.id.to_s
      @redis.set  client_id+packet.id.to_s,packet
    end

  end

  def get(&block)
    id=@redis.zrangebyscore "mqtt-publish",0,@time.to_i-@retry_time.to_i
   # puts "id:#{id},#{@time},#{@retry_time},#{@redis}"
    id.each do |id|
      yield @redis.get(id)
    #  @redis.zadd "mqtt-publish",@time,id
    end
  end


  def  remove(id)
    @redis.multi do
      @redis.zrem "mqtt-publish",id
      @redis.del  id
    end

  end
end