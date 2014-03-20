class Character
  attr_accessor :uid, :world, :mobile_id, :na_id, :login_token

  def initialize(obj)
    self.uid = obj[:uid]
    self.world = obj[:world]
    self.mobile_id = obj[:mobile_id]
    self.na_id = obj[:na_id]

    auth
  end

  def auth
    response = self.response({
        'action' => 'UserService.signin',
        'mobileId' => mobile_id,
        'naid' => na_id,
        'access_token' => '9',

    })
    self.login_token = response['loginToken']
  end

  def info
    response = self.response({
      action: 'UserService.updateSeed',
      uid: uid,
      world: world,
      loginToken: login_token
    })
    true
  end

  def go(target = '0_3_15', send = false)
    self.send(send ? 'response' : 'request', {
         action: 'QuestService.move',
         id: target,
         uid: uid,
         world: world,
         loginToken: login_token
     })
  end

  def run(count = 200, concurency = 100)
    hydra = Typhoeus::Hydra.new(max_concurrency: concurency )
    all = []
    count.times do
        all << go
        hydra.queue(all.last)
    end
    hydra.run
    all
  end

  protected
  def request(body)
    Typhoeus::Request.new(
        "http://heroesofcamelot.com/public/gateway.php",
        method: :post,
        headers: {
            'User-Agent' => 'Dalvik/1.6.0 (Linux; U; Android 4.0.4; GT-I9300 Build/IMM76D)',
            'Accept-Encoding' => 'gzip'
        },
        body: body.to_query
    )
  end

  def response(body)
    JSON.parse( request(body).run.body )
  end

end
