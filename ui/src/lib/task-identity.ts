import type { Task } from '@/schemas/task'

export type TaskIdentity = Required<Pick<Task['metadata'], 'namespace' | 'name' | 'uid'>>

export function taskIdentity({ namespace, name, uid }: Task['metadata']): TaskIdentity | null {
  return namespace && name && uid ? { namespace, name, uid } : null
}

export function matchesTaskIdentity(metadata: Task['metadata'], target: TaskIdentity): boolean {
  return metadata.namespace === target.namespace && metadata.name === target.name && metadata.uid === target.uid
}
