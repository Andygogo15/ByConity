/*
 * Copyright 2016-2023 ClickHouse, Inc.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


/*
 * This file may have been modified by Bytedance Ltd. and/or its affiliates (“ Bytedance's Modifications”).
 * All Bytedance's Modifications are Copyright (2023) Bytedance Ltd. and/or its affiliates.
 */

#include "DiskRestartProxy.h"

#include <IO/ReadBufferFromFileDecorator.h>
#include <IO/WriteBufferFromFileDecorator.h>

namespace DB
{
namespace ErrorCodes
{
    extern const int DEADLOCK_AVOIDED;
}

using Millis = std::chrono::milliseconds;
using Seconds = std::chrono::seconds;

/// Holds restart read lock till buffer destruction.
class RestartAwareReadBuffer : public ReadBufferFromFileDecorator
{
public:
    RestartAwareReadBuffer(const DiskRestartProxy & disk, std::unique_ptr<ReadBufferFromFileBase> impl_)
        : ReadBufferFromFileDecorator(std::move(impl_)), lock(disk.mutex) { }

private:
    ReadLock lock;
};

/// Holds restart read lock till buffer finalize.
class RestartAwareWriteBuffer : public WriteBufferFromFileDecorator
{
public:
    RestartAwareWriteBuffer(const DiskRestartProxy & disk, std::unique_ptr<WriteBuffer> impl_)
        : WriteBufferFromFileDecorator(std::move(impl_)), lock(disk.mutex) { }

    virtual ~RestartAwareWriteBuffer() override
    {
        try
        {
            finalize();
        }
        catch (...)
        {
            tryLogCurrentException(__PRETTY_FUNCTION__);
        }
    }

protected:
    void finalizeImpl() override
    {
        WriteBufferFromFileDecorator::finalizeImpl();
        lock.unlock();
    }

private:
    ReadLock lock;
};

DiskRestartProxy::DiskRestartProxy(DiskPtr & delegate_)
    : DiskDecorator(delegate_) { }

ReservationPtr DiskRestartProxy::reserve(UInt64 bytes)
{
    ReadLock lock (mutex);
    auto ptr = DiskDecorator::reserve(bytes);
    if (ptr)
    {
        auto disk_ptr = std::static_pointer_cast<DiskRestartProxy>(shared_from_this());
        return std::make_unique<ReservationDelegate>(std::move(ptr), disk_ptr);
    }
    return ptr;
}

const String & DiskRestartProxy::getPath() const
{
    ReadLock lock (mutex);
    return DiskDecorator::getPath();
}

DiskStats DiskRestartProxy::getTotalSpace(bool) const
{
    ReadLock lock (mutex);
    return DiskDecorator::getTotalSpace();
}

DiskStats DiskRestartProxy::getAvailableSpace() const
{
    ReadLock lock (mutex);
    return DiskDecorator::getAvailableSpace();
}

DiskStats DiskRestartProxy::getUnreservedSpace() const
{
    ReadLock lock (mutex);
    return DiskDecorator::getUnreservedSpace();
}

DiskStats DiskRestartProxy::getKeepingFreeSpace() const
{
    ReadLock lock (mutex);
    return DiskDecorator::getKeepingFreeSpace();
}

bool DiskRestartProxy::exists(const String & path) const
{
    ReadLock lock (mutex);
    return DiskDecorator::exists(path);
}

bool DiskRestartProxy::isFile(const String & path) const
{
    ReadLock lock (mutex);
    return DiskDecorator::isFile(path);
}

bool DiskRestartProxy::isDirectory(const String & path) const
{
    ReadLock lock (mutex);
    return DiskDecorator::isDirectory(path);
}

size_t DiskRestartProxy::getFileSize(const String & path) const
{
    ReadLock lock (mutex);
    return DiskDecorator::getFileSize(path);
}

void DiskRestartProxy::createDirectory(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::createDirectory(path);
}

void DiskRestartProxy::createDirectories(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::createDirectories(path);
}

void DiskRestartProxy::clearDirectory(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::clearDirectory(path);
}

void DiskRestartProxy::moveDirectory(const String & from_path, const String & to_path)
{
    ReadLock lock (mutex);
    DiskDecorator::moveDirectory(from_path, to_path);
}

DiskDirectoryIteratorPtr DiskRestartProxy::iterateDirectory(const String & path)
{
    ReadLock lock (mutex);
    return DiskDecorator::iterateDirectory(path);
}

void DiskRestartProxy::createFile(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::createFile(path);
}

void DiskRestartProxy::moveFile(const String & from_path, const String & to_path)
{
    ReadLock lock (mutex);
    DiskDecorator::moveFile(from_path, to_path);
}

void DiskRestartProxy::replaceFile(const String & from_path, const String & to_path)
{
    ReadLock lock (mutex);
    DiskDecorator::replaceFile(from_path, to_path);
}

void DiskRestartProxy::copy(const String & from_path, const std::shared_ptr<IDisk> & to_disk, const String & to_path)
{
    ReadLock lock (mutex);
    DiskDecorator::copy(from_path, to_disk, to_path);
}

void DiskRestartProxy::listFiles(const String & path, std::vector<String> & file_names)
{
    ReadLock lock (mutex);
    DiskDecorator::listFiles(path, file_names);
}

std::unique_ptr<ReadBufferFromFileBase> DiskRestartProxy::readFile(
    const String & path, const ReadSettings& settings)
    const
{
    ReadLock lock (mutex);
    auto impl = DiskDecorator::readFile(path, settings);
    return std::make_unique<RestartAwareReadBuffer>(*this, std::move(impl));
}

std::unique_ptr<WriteBufferFromFileBase> DiskRestartProxy::writeFile(const String & path, const WriteSettings& settings)
{
    ReadLock lock (mutex);
    auto impl = DiskDecorator::writeFile(path, settings);
    return std::make_unique<RestartAwareWriteBuffer>(*this, std::move(impl));
}

void DiskRestartProxy::removeFile(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::removeFile(path);
}

void DiskRestartProxy::removeFileIfExists(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::removeFileIfExists(path);
}

void DiskRestartProxy::removeDirectory(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::removeDirectory(path);
}

void DiskRestartProxy::removeRecursive(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::removeRecursive(path);
}

void DiskRestartProxy::removeSharedFile(const String & path, bool keep_s3)
{
    ReadLock lock (mutex);
    DiskDecorator::removeSharedFile(path, keep_s3);
}

void DiskRestartProxy::removeSharedRecursive(const String & path, bool keep_s3)
{
    ReadLock lock (mutex);
    DiskDecorator::removeSharedRecursive(path, keep_s3);
}

void DiskRestartProxy::setLastModified(const String & path, const Poco::Timestamp & timestamp)
{
    ReadLock lock (mutex);
    DiskDecorator::setLastModified(path, timestamp);
}

Poco::Timestamp DiskRestartProxy::getLastModified(const String & path)
{
    ReadLock lock (mutex);
    return DiskDecorator::getLastModified(path);
}

void DiskRestartProxy::setReadOnly(const String & path)
{
    ReadLock lock (mutex);
    DiskDecorator::setReadOnly(path);
}

void DiskRestartProxy::createHardLink(const String & src_path, const String & dst_path)
{
    ReadLock lock (mutex);
    DiskDecorator::createHardLink(src_path, dst_path);
}

void DiskRestartProxy::truncateFile(const String & path, size_t size)
{
    ReadLock lock (mutex);
    DiskDecorator::truncateFile(path, size);
}

String DiskRestartProxy::getUniqueId(const String & path) const
{
    ReadLock lock (mutex);
    return DiskDecorator::getUniqueId(path);
}

bool DiskRestartProxy::checkUniqueId(const String & id) const
{
    ReadLock lock (mutex);
    return DiskDecorator::checkUniqueId(id);
}

void DiskRestartProxy::restart()
{
    /// Speed up processing unhealthy requests.
    DiskDecorator::shutdown();

    WriteLock lock (mutex, std::defer_lock);

    LOG_INFO(log, "Acquiring lock to restart disk {}", DiskDecorator::getName());

    auto start_time = std::chrono::steady_clock::now();
    auto lock_timeout = Seconds(120);
    do
    {
        /// Use a small timeout to not block read operations for a long time.
        if (lock.try_lock_for(Millis(10)))
            break;
    } while (std::chrono::steady_clock::now() - start_time < lock_timeout);

    if (!lock.owns_lock())
        throw Exception("Failed to acquire restart lock within timeout. Client should retry.", ErrorCodes::DEADLOCK_AVOIDED);

    LOG_INFO(log, "Restart lock acquired. Restarting disk {}", DiskDecorator::getName());

    DiskDecorator::startup();

    LOG_INFO(log, "Disk restarted {}", DiskDecorator::getName());
}

}
