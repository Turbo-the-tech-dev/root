/**
 * Imperial Logging Utility: Sector 00 Telemetry
 * Provides structured logging with severity levels and error tracking.
 */

type LogLevel = 'INFO' | 'WARN' | 'ERROR' | 'FATAL';

interface LogEntry {
  timestamp: string;
  level: LogLevel;
  message: string;
  context?: any;
  stack?: string;
}

class ImperialLogger {
  private static instance: ImperialLogger;

  private constructor() {}

  public static getInstance(): ImperialLogger {
    if (!ImperialLogger.instance) {
      ImperialLogger.instance = new ImperialLogger();
    }
    return ImperialLogger.instance;
  }

  private formatMessage(level: LogLevel, message: string, context?: any): LogEntry {
    return {
      timestamp: new Date().toISOString(),
      level,
      message,
      context,
      stack: level === 'ERROR' || level === 'FATAL' ? new Error().stack : undefined,
    };
  }

  private shipLog(entry: LogEntry) {
    // In a real implementation, this would send logs to a service like Sentry or CloudWatch.
    // For now, we use a high-impact console output with Imperial formatting.
    const color = entry.level === 'ERROR' || entry.level === 'FATAL' ? '\x1b[31m' : entry.level === 'WARN' ? '\x1b[33m' : '\x1b[32m';
    const reset = '\x1b[0m';

    console.log(`${color}[${entry.level}] ${entry.timestamp}${reset} | ${entry.message}`);
    if (entry.context) {
      console.log('Context:', JSON.stringify(entry.context, null, 2));
    }
    if (entry.stack) {
      console.log('Stack Trace:', entry.stack);
    }
  }

  public info(message: string, context?: any) {
    this.shipLog(this.formatMessage('INFO', message, context));
  }

  public warn(message: string, context?: any) {
    this.shipLog(this.formatMessage('WARN', message, context));
  }

  public error(message: string, error?: Error | any) {
    const entry = this.formatMessage('ERROR', message, error);
    if (error instanceof Error) {
      entry.stack = error.stack;
    }
    this.shipLog(entry);
  }

  public fatal(message: string, error?: Error | any) {
    const entry = this.formatMessage('FATAL', message, error);
    if (error instanceof Error) {
      entry.stack = error.stack;
    }
    this.shipLog(entry);
    // Imperial protocol: Shutdown on fatal error
    // process.exit(1); 
  }
}

export const Logger = ImperialLogger.getInstance();
