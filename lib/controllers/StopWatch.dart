class StopWatch extends Stopwatch{
  int _starterMilliseconds = 0;

  StopWatch();

  get elapsedDuration{
    return Duration(
        microseconds:
        this.elapsedMicroseconds + (this._starterMilliseconds * 1000)
    );
  }

  get elapsedMillis{
    return this.elapsedMilliseconds + this._starterMilliseconds;
  }

  set milliseconds(int timeInMilliseconds){
    this._starterMilliseconds = timeInMilliseconds;
  }

}